:: Setup on Windows
:: Install Git from: https://github.com/git-for-windows/git/releases/download/v2.37.1.windows.1/Git-2.37.1-64-bit.exe
:: Install Sublime Text and Sublime Merge from: https://www.sublimetext.com/download_thanks?target=win-x64 and https://www.sublimemerge.com/download_thanks?target=win-x64
:: Install Alacritty from: https://github.com/alacritty/alacritty/releases/download/v0.10.0/Alacritty-v0.10.0-installer.msi
:: Install FiraCode font from: https://github.com/tonsky/FiraCode/wiki/Installing
:: Remap Caps Lock to Ctrl with instructions here: https://gist.github.com/joshschmelzle/5e88dabc71014d7427ff01bca3fed33d

set DOTFILES_DIR=%USERPROFILE%\Developer\dotfiles
echo "Setting Dotfiles dir as: %DOTFILES_DIR%"

:: Alacritty
echo %DOTFILES_DIR%\alacritty\alacritty_win.yml
echo %APPDATA%\alacritty\alacritty.yml
if not exist "%APPDATA%\alacritty" (
	echo "Creating %APPDATA%\alacritty ..."
	mkdir "%APPDATA%\alacritty"
)
xcopy /F "%DOTFILES_DIR%\alacritty\alacritty_win.yml" "%APPDATA%\alacritty\alacritty.yml"

:: Sublime Text and Sublime Merge
if not exist "%APPDATA%\Sublime Text" (
	echo "%APPDATA%\Sublime Text does not exist, run Sublime Text to create it!"
)
xcopy /F /S /E "%DOTFILES_DIR%\sublime\text\User" "%APPDATA%\Sublime Text\Packages\User"

if not exist "%APPDATA%\Sublime Merge" (
	echo "%APPDATA%\Sublime Merge does not exist, run Sublime Merge to create it!"
)
xcopy /F /S /E "%DOTFILES_DIR%\sublime\merge\User" "%APPDATA%\Sublime Merge\Packages\User"

