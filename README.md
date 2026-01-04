# Dotfiles Setup

## Manual Installation Steps

Before using these dotfiles, manually install the following tools:

### 1. FiraCode Fonts
Install FiraCode fonts from the official installation guide:
https://github.com/tonsky/FiraCode/wiki/Installing

### 2. Sublime Text
Install Sublime Text from:
https://www.sublimetext.com/

### 3. Sublime Merge
Install Sublime Merge from:
https://www.sublimemerge.com/dev

### 4. Alacritty
Install Alacritty terminal emulator from:
https://alacritty.org/

## Windows-Specific Setup

### Python
Install Python from the official Python website:
https://www.python.org/downloads/

### Git Bash and Zsh
On Windows, install Git Bash first:
https://gitforwindows.org/

Then install Zsh in Git Bash by following these steps:
https://dominikrys.com/posts/zsh-in-git-bash-on-windows/#installing-zsh-in-git-bash

Create a `.bashrc` with the following contents:

```sh
/c/Windows/System32/chcp.com 65001 > /dev/null 2>&1

if [ -t 1 ]; then
  exec zsh
fi
```
