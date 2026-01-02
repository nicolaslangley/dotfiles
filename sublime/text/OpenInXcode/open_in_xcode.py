import sublime
import sublime_plugin
import subprocess

class OpenInXcodeCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        filePath = self.view.file_name()
        
        if filePath is None:
            sublime.status_message("Open In Xcode: File not saved")
            return

        selection = self.view.sel()
        if not selection:
            row = 1
        else:
            selectionPos = selection[0].begin()
            (row, col) = self.view.rowcol(selectionPos)
            row += 1  # rows returned by rowcol() are 0-based.

        try:
            subprocess.Popen(["xed", "--line", str(row), filePath])
        except FileNotFoundError:
            sublime.error_message("Open In Xcode: 'xed' tool not found. Please install Xcode Command Line Tools.")
        except Exception as e:
            sublime.error_message("Open In Xcode: " + str(e))