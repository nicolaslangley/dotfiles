import copy
import os
import html
import json

import sublime
import sublime_plugin

SETTINGS_FILE = "LLDBBreakpoints.sublime-settings"
REGION_KEY = "lldb_breakpoints"
REGION_KEY_DISABLED = "lldb_breakpoints_disabled"
PANEL_NAME = "lldb_breakpoints"

# Base syntax scopes for the languages LLDB resolves file/line breakpoints in.
# These are the compiled languages that emit DWARF/debug info LLDB understands;
# setting a breakpoint anywhere else (Python, JSON, Markdown, ...) would never
# bind, so we only offer the gutter/menu/keybinding actions in these. Overridable
# via the "lldb_scopes" setting. Matched as Sublime selectors, so a base scope
# like "source.c++" also covers its embedded/derived scopes.
DEFAULT_SCOPES = [
    "source.c",
    "source.c++",
    "source.objc",
    "source.objc++",
    "source.swift",
    "source.rust",
]

# The breakpoints file uses LLDB's native serialization format, i.e. the
# output of `breakpoint write -f <file>` and the input to `breakpoint read`.
# It is a JSON array of { "Breakpoint": {...} } entries. This plugin only
# manages the file/line ("FileAndLine") entries that correspond to gutter
# clicks; any other entries (e.g. "SymbolName") are preserved untouched.


def breakpoints_path():
    path = sublime.load_settings(SETTINGS_FILE).get("breakpoints_file", "")
    return os.path.expanduser(path) if path else None


def is_lldb_view(view):
    """True if this view's language is one LLDB can set file/line breakpoints in.

    Gates every "add breakpoint" path (gutter click, F9, command palette, context
    menu) so breakpoints can only be placed in LLDB-debuggable source. A view with
    no syntax, or one whose base scope isn't in DEFAULT_SCOPES / the "lldb_scopes"
    setting, returns False. Unsaved views also fail -- a breakpoint needs a path.
    """
    if view is None or view.file_name() is None:
        return False
    scopes = sublime.load_settings(SETTINGS_FILE).get("lldb_scopes", DEFAULT_SCOPES)
    if not scopes:
        return False
    # Comma-joined scopes form a Sublime selector where "," means OR; match_selector
    # at point 0 tests the base syntax scope (and its hierarchy) against that set.
    return view.match_selector(0, ", ".join(scopes))


# load_breakpoints() sits on hot paths: render() runs it on every view activation,
# and render_all() runs it once per open view. Reading + parsing + deduping the
# file each time would be wasteful, so cache the parsed result keyed on the file's
# path+mtime+size. An unchanged file is served from cache after a single os.stat;
# an external write (e.g. LLDB's `breakpoint write` during a debug session) changes
# the mtime and invalidates it, so freshness is preserved.
_BP_CACHE = {"sig": None, "entries": []}


def load_breakpoints():
    """Return the list of LLDB breakpoint entries from the file (cached).

    Callers get a deep copy, so in-place edits (enable/disable, delete) never
    mutate the cached list.
    """
    path = breakpoints_path()
    if not path:
        return []
    try:
        st = os.stat(path)
    except OSError:
        return []  # missing or unreadable file -> no breakpoints
    sig = (path, st.st_mtime_ns, st.st_size)
    if _BP_CACHE["sig"] != sig:
        try:
            with open(path, "r") as f:
                data = json.load(f)
        except (ValueError, OSError):
            data = []
        _BP_CACHE["entries"] = _dedup(data) if isinstance(data, list) else []
        _BP_CACHE["sig"] = sig
    return copy.deepcopy(_BP_CACHE["entries"])


def save_breakpoints(entries):
    path = breakpoints_path()
    if not path:
        sublime.status_message("Breakpoints: set 'breakpoints_file' in settings")
        return False
    # Dedup on the way out too, so every write -- adding, removing, enabling,
    # disabling -- persists one entry per location regardless of where `entries`
    # came from. Pairs with the dedup in load_breakpoints().
    entries = _dedup(entries)
    try:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w") as f:
            json.dump(entries, f, indent=4)
        # Prime the cache with what we just wrote so the render_all() that
        # follows a mutation doesn't have to read it straight back off disk.
        try:
            st = os.stat(path)
            _BP_CACHE["sig"] = (path, st.st_mtime_ns, st.st_size)
            _BP_CACHE["entries"] = entries
        except OSError:
            _BP_CACHE["sig"] = None  # force a reload next time
        return True
    except OSError as e:
        sublime.error_message("Breakpoints: could not write file: " + str(e))
        return False


def _is_file_line(entry):
    try:
        return entry["Breakpoint"]["BKPTResolver"]["Type"] == "FileAndLine"
    except (KeyError, TypeError):
        return False


def _entry_file_line(entry):
    opts = entry["Breakpoint"]["BKPTResolver"]["Options"]
    return opts.get("FileName"), opts.get("LineNumber")


def _is_enabled(entry):
    try:
        return entry["Breakpoint"]["BKPTOptions"].get("EnabledState", True)
    except (KeyError, TypeError):
        return True


def _set_enabled(entry, value):
    entry.setdefault("Breakpoint", {}).setdefault("BKPTOptions", {})["EnabledState"] = value


def _dedup(entries):
    """Collapse breakpoints that point at the same location, keeping the first.

    The file is shared with LLDB (`breakpoint read`/`write`) and can accumulate
    duplicate entries; deduping here means the panel, gutter, and the index-based
    panel actions all see one entry per location. FileAndLine entries are matched
    the same way `_matches` matches an open file -- by basename and line -- so a
    bare-basename entry and a full-path entry for the same spot collapse into one;
    when they do, the full-path variant is kept so the entry stays navigable.
    Other resolver types are matched on their full resolver+filter. Order is
    otherwise preserved.
    """
    def key(entry):
        if _is_file_line(entry):
            file_name, line = _entry_file_line(entry)
            return ("FileAndLine", os.path.basename(file_name or ""), line)
        bp = entry.get("Breakpoint", {}) if isinstance(entry, dict) else {}
        return ("other", json.dumps([bp.get("BKPTResolver"), bp.get("SearchFilter")], sort_keys=True))

    def is_abs_file(entry):
        if not _is_file_line(entry):
            return False
        file_name, _ = _entry_file_line(entry)
        return os.path.isabs(file_name or "")

    seen, out = {}, []
    for entry in entries:
        k = key(entry)
        if k in seen:
            # Same location already kept. Prefer a full-path variant over a
            # bare-basename one so the surviving entry stays navigable.
            idx = seen[k]
            if is_abs_file(entry) and not is_abs_file(out[idx]):
                out[idx] = entry
            continue
        seen[k] = len(out)
        out.append(entry)
    return out


def _describe(entry):
    """Quick-panel display for an entry: (primary, secondary, path, line).

    path/line are None when the breakpoint isn't a navigable file/line one.
    """
    try:
        resolver = entry["Breakpoint"]["BKPTResolver"]
    except (KeyError, TypeError):
        return ("(unrecognized breakpoint)", "", None, None)
    options = resolver.get("Options", {})
    suffix = "" if _is_enabled(entry) else "  (disabled)"
    if resolver.get("Type") == "FileAndLine":
        path = options.get("FileName", "")
        line = options.get("LineNumber")
        return ("{}:{}{}".format(os.path.basename(path), line, suffix), path, path, line)
    if resolver.get("Type") == "SymbolName":
        names = ", ".join(options.get("SymbolNames", []))
        return ("ƒ {}{}".format(names, suffix), "symbol breakpoint", None, None)
    return ("{}{}".format(resolver.get("Type") or "breakpoint", suffix), "", None, None)


def _matches(file_name, view_path):
    """A stored FileName matches the open file by full path or by basename.

    We store full paths, but match basenames too so breakpoints written
    elsewhere (e.g. by `breakpoint set --file foo.cpp`) still show up.
    """
    if not file_name or not view_path:
        return False
    return (file_name == view_path or
            os.path.basename(file_name) == os.path.basename(view_path))


def make_entry(file_path, line):
    """Build an LLDB FileAndLine breakpoint entry (matches `breakpoint write`)."""
    return {
        "Breakpoint": {
            "BKPTOptions": {
                "AutoContinue": False,
                "ConditionText": "",
                "EnabledState": True,
                "IgnoreCount": 0,
                "OneShotState": False,
            },
            "BKPTResolver": {
                "Options": {
                    "Column": 0,
                    "Exact": False,
                    "FileName": file_path,
                    "Inlines": True,
                    "LineNumber": line,
                    "Offset": 0,
                    "SkipPrologue": True,
                },
                "Type": "FileAndLine",
            },
            "Hardware": False,
            "SearchFilter": {"Options": {}, "Type": "Unconstrained"},
        }
    }


def _draw(view, key, regions, scope):
    if regions:
        # HIDDEN draws no decoration in the text body, only the gutter icon.
        view.add_regions(key, regions, scope, "circle", sublime.HIDDEN)
    else:
        view.erase_regions(key)


def render(view):
    """Draw a gutter icon on every breakpoint line in this view.

    Enabled breakpoints are red; disabled ones are blue.
    """
    path = view.file_name()
    enabled, disabled = [], []
    if path:
        for entry in load_breakpoints():
            if not _is_file_line(entry):
                continue
            file_name, line = _entry_file_line(entry)
            if not line or not _matches(file_name, path):
                continue
            pt = view.text_point(line - 1, 0)
            bucket = enabled if _is_enabled(entry) else disabled
            bucket.append(sublime.Region(pt, pt))
    _draw(view, REGION_KEY, enabled, "region.redish")
    _draw(view, REGION_KEY_DISABLED, disabled, "region.bluish")


def render_all():
    """Refresh gutter icons in every file view and any open breakpoints panel."""
    for window in sublime.windows():
        for view in window.views():
            render(view)
        panel = window.find_output_panel(PANEL_NAME)
        if panel is not None:
            _render_panel(panel)


def plugin_loaded():
    render_all()


def _gutter_click_line(view, event):
    """Return the 1-based line if the click landed in the gutter, else None."""
    x, y = event.get("x"), event.get("y")
    if x is None or y is None:
        return None
    row = view.rowcol(view.window_to_text((x, y)))[0]
    # Window x where this line's text begins; the gutter is everything left of it.
    text_x = view.layout_to_window(view.text_to_layout(view.text_point(row, 0)))[0]
    return row + 1 if x < text_x else None


class LldbBreakpointsGutterListener(sublime_plugin.EventListener):
    def on_text_command(self, view, command_name, args):
        # A left click is dispatched as "drag_select" carrying the mouse event.
        # If it landed in the gutter, toggle a breakpoint instead of moving
        # the caret (returning a command replaces the default behaviour).
        if command_name != "drag_select" or not isinstance(args, dict):
            return None
        if not is_lldb_view(view):
            return None  # let the click move the caret as usual
        event = args.get("event")
        if not event:
            return None
        line = _gutter_click_line(view, event)
        if line is None:
            return None
        return ("lldb_breakpoints_toggle", {"line": line})

    def on_load_async(self, view):
        render(view)

    def on_activated_async(self, view):
        # Re-read the file when the panel regains focus so it reflects changes
        # made elsewhere (e.g. breakpoints LLDB wrote during a debug session).
        if view.settings().get("lldb_breakpoints_panel"):
            _render_panel(view)
        else:
            render(view)

    def on_close(self, view):
        _PHANTOM_SETS.pop(view.id(), None)


def _caret_line(view, line):
    """Resolve an explicit line arg, else the caret's 1-based line."""
    if line is not None:
        return line
    sel = view.sel()
    return view.rowcol(sel[0].begin())[0] + 1 if len(sel) else 1


def _breakpoint_on_line(view, line=None):
    """Return the file/line breakpoint entry on the given line, or None."""
    path = view.file_name()
    if not path:
        return None
    line = _caret_line(view, line)
    for entry in load_breakpoints():
        if not _is_file_line(entry):
            continue
        file_name, entry_line = _entry_file_line(entry)
        if entry_line == line and _matches(file_name, path):
            return entry
    return None


class LldbBreakpointsToggleCommand(sublime_plugin.TextCommand):
    # Hide/disable everywhere (context menu, command palette, F9) outside the
    # languages LLDB can debug, so breakpoints are only ever placed where they bind.
    def is_visible(self, line=None):
        return is_lldb_view(self.view)

    def is_enabled(self, line=None):
        return is_lldb_view(self.view)

    # Relabel the menu item based on whether a breakpoint already exists here.
    def description(self, line=None):
        return "Remove Breakpoint" if _breakpoint_on_line(self.view, line) else "Add Breakpoint"

    def run(self, edit, line=None):
        view = self.view
        path = view.file_name()
        if not path:
            sublime.status_message("Breakpoints: save the file first")
            return
        # Keybindings fire regardless of is_enabled(), so guard the action too.
        if not is_lldb_view(view):
            sublime.status_message("Breakpoints: not an LLDB-supported language")
            return
        if line is None:
            line = view.rowcol(view.sel()[0].begin())[0] + 1

        kept = []
        removed = False
        for entry in load_breakpoints():
            if _is_file_line(entry):
                file_name, entry_line = _entry_file_line(entry)
                if entry_line == line and _matches(file_name, path):
                    removed = True
                    continue
            kept.append(entry)
        if not removed:
            kept.append(make_entry(path, line))

        if save_breakpoints(kept):
            render_all()
            sublime.status_message("Breakpoints: {} line {}".format(
                "removed" if removed else "added", line))


class LldbBreakpointsToggleEnabledCommand(sublime_plugin.TextCommand):
    """Enable/disable the breakpoint on the current line (keeps it in the file)."""

    # Only show this item in an LLDB-supported view when a breakpoint exists on
    # the line, and label it with the action that will happen.
    def is_visible(self, line=None):
        return is_lldb_view(self.view) and _breakpoint_on_line(self.view, line) is not None

    def is_enabled(self, line=None):
        return self.is_visible(line)

    def description(self, line=None):
        entry = _breakpoint_on_line(self.view, line)
        if entry is None:
            return "Enable/Disable Breakpoint"
        return "Disable Breakpoint" if _is_enabled(entry) else "Enable Breakpoint"

    def run(self, edit, line=None):
        view = self.view
        path = view.file_name()
        if not path:
            sublime.status_message("Breakpoints: save the file first")
            return
        if line is None:
            line = view.rowcol(view.sel()[0].begin())[0] + 1

        entries = load_breakpoints()
        state = None
        for entry in entries:
            if not _is_file_line(entry):
                continue
            file_name, entry_line = _entry_file_line(entry)
            if entry_line == line and _matches(file_name, path):
                state = not _is_enabled(entry)
                _set_enabled(entry, state)
                break
        if state is None:
            sublime.status_message("Breakpoints: no breakpoint on line {}".format(line))
            return

        if save_breakpoints(entries):
            render_all()
            sublime.status_message("Breakpoints: {} line {}".format(
                "enabled" if state else "disabled", line))


def _remove_all():
    """Remove every breakpoint, after confirming."""
    if not load_breakpoints():
        sublime.status_message("Breakpoints: none set")
        return
    if not sublime.ok_cancel_dialog("Remove all breakpoints?", "Remove All"):
        return
    if save_breakpoints([]):
        render_all()
        sublime.status_message("Breakpoints: removed all")


class LldbBreakpointsRemoveAllCommand(sublime_plugin.ApplicationCommand):
    def run(self):
        _remove_all()


# ── breakpoints panel ──────────────────────────────────────────────────────
#
# A dedicated read-only view that renders all breakpoints as one minihtml
# phantom. The checkbox (☑/☐) and ✕ glyphs are <a> links; clicking them fires
# the phantom's on_navigate callback. This is the canonical way to build a
# panel with clickable controls.

_PHANTOM_SETS = {}

_PANEL_HEAD = """
<body id="lldb-breakpoints">
<style>
  html { background-color: var(--background); }
  body { margin: 0; padding: 0.6rem 0.9rem; color: var(--foreground); }
  .title { color: color(var(--foreground) alpha(0.55)); margin-bottom: 0.7rem; }
  .row { margin-bottom: 0.3rem; }
  a { text-decoration: none; }
  .boxon { color: var(--greenish); font-size: 1.3rem; }
  .boxoff { color: var(--bluish); font-size: 1.3rem; }
  .lblon { color: var(--foreground); }
  .lbloff { color: color(var(--foreground) alpha(0.45)); }
  .del { color: var(--redish); font-size: 1.3rem;}
  .path { color: color(var(--foreground) alpha(0.4)); padding: 0.6rem 0.9rem; }
  .empty { color: color(var(--foreground) alpha(0.5)); }
  .footer { margin-top: 0.7rem; }
  .removeall { color: var(--redish); }
</style>
<div class="title">LLDB Breakpoints &mdash; click ☑/☐ to enable/disable, ✕ to delete</div>
"""

_PANEL_TAIL = "</body>"


def _panel_html(entries):
    if not entries:
        return _PANEL_HEAD + '<div class="empty">No breakpoints set.</div>' + _PANEL_TAIL
    rows = []
    for index, entry in enumerate(entries):
        primary, secondary, path, line = _describe(entry)
        enabled = _is_enabled(entry)
        box = "☑" if enabled else "☐"
        box_cls = "boxon" if enabled else "boxoff"
        lbl_cls = "lblon" if enabled else "lbloff"
        label = html.escape(primary)
        if path and line:
            label = '<a class="{}" href="goto:{}">{}</a>'.format(lbl_cls, index, label)
        else:
            label = '<span class="{}">{}</span>'.format(lbl_cls, label)
        tail = ('<span class="path">{}</span>'.format(html.escape(secondary))
                if secondary else "")
        rows.append(
            '<div class="row">'
            '<a class="{box_cls}" href="toggle:{i}">{box}</a> '
            '{label}'
            '{tail}'
            '<a class="del" href="delete:{i}">✕</a>'
            '</div>'.format(box_cls=box_cls, box=box, label=label, tail=tail, i=index))
    footer = '<div class="footer"><a class="removeall" href="removeall">Remove All Breakpoints</a></div>'
    return _PANEL_HEAD + "".join(rows) + footer + _PANEL_TAIL


def _render_panel(view):
    phantoms = _PHANTOM_SETS.get(view.id())
    if phantoms is None:
        phantoms = sublime.PhantomSet(view, "lldb_breakpoints")
        _PHANTOM_SETS[view.id()] = phantoms
    phantoms.update([sublime.Phantom(
        sublime.Region(0),
        _panel_html(load_breakpoints()),
        sublime.LAYOUT_BLOCK,
        lambda href: _panel_navigate(view, href))])


def _panel_navigate(view, href):
    action, _, raw_index = href.partition(":")
    if action == "removeall":
        _remove_all()
        return
    try:
        index = int(raw_index)
    except ValueError:
        return
    entries = load_breakpoints()
    if not (0 <= index < len(entries)):
        _render_panel(view)  # list changed underneath us; just refresh
        return
    if action == "goto":
        _, _, path, line = _describe(entries[index])
        if path and line and view.window():
            view.window().open_file("{}:{}:0".format(path, line),
                                    sublime.ENCODED_POSITION)
        return
    if action == "toggle":
        _set_enabled(entries[index], not _is_enabled(entries[index]))
    elif action == "delete":
        del entries[index]
    else:
        return
    if save_breakpoints(entries):
        render_all()


class LldbBreakpointsPanelCommand(sublime_plugin.WindowCommand):
    """Show the breakpoints panel at the bottom of the window."""

    def run(self):
        panel = self.window.create_output_panel(PANEL_NAME)
        settings = panel.settings()
        settings.set("lldb_breakpoints_panel", True)
        settings.set("gutter", False)
        settings.set("line_numbers", False)
        settings.set("draw_white_space", "none")
        settings.set("draw_indent_guides", False)
        settings.set("scroll_past_end", False)
        panel.set_read_only(True)
        _render_panel(panel)
        self.window.run_command("show_panel", {"panel": "output." + PANEL_NAME})
