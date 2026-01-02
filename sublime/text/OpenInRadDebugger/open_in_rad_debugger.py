import sublime
import sublime_plugin
import subprocess

class OpenInRadDebuggerCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        filePath = self.view.file_name()
        
        if filePath is None:
            sublime.status_message("Open In RAD Debugger: File not saved")
            return

        selection = self.view.sel()
        if not selection:
            row = 1
            col = 1
        else:
            selectionPos = selection[0].begin()
            (row, col) = self.view.rowcol(selectionPos)
            row += 1  # rows returned by rowcol() are 0-based.
            col += 1  # cols returned by rowcol() are 0-based.

        binaryPath = "C:\\Users\\nicolaslangley\\Developer\\raddbg\\raddbg.exe"
        targetLocation = filePath + ":" + str(row) + ":" + str(col)

        try:
            subprocess.Popen([binaryPath, "--ipc", "find_code_location", targetLocation])
        except FileNotFoundError:
            sublime.error_message("Open In RAD Debugger: 'raddbg' tool not found. Please install RAD Debugger.")
        except Exception as e:
            sublime.error_message("Open In RAD Debugger: " + str(e))