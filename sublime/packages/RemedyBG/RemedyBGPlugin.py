import sublime
import sublime_plugin
import subprocess


class SetRemedyLocationCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        filePath = self.view.file_name()

        selectionPos = self.view.sel()[0].begin()
        (row, col) = self.view.rowcol(selectionPos)
        col += 1  # cols returned by rowcol() are 0-based.
        row += 1  # rows returned by rowcol() are 0-based.

        cursorPath = filePath + " " + str(row)
        data = cursorPath.encode()

        settings = sublime.load_settings('RemedyBG.sublime-settings')
        binary_path = settings.get('binary_path')

        subprocess.Popen([binary_path, "open-file", filePath, str(row)])
