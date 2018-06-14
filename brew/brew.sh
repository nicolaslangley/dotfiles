# Update Homebrew, formulae, and packages
brew update
brew upgrade

core=(
zsh
zsh-completions
ack
cmake
ctags
dockutil
git
sqlite
the_silver_searcher
tmux
tree
neovim
ninja
wget
python
python3
tig
)

libs=(
glew
imagemagick
opencv3
)

python=(
numpy
scipy
matplotlib
boost-python
)

cpp=(
gdb
boost
)

if [ "$1" = "core" ]; then 
    brew install "${core[@]}"
else
    if [ "$1" = "libs" ]; then
        brew install "${libs[@]}"
    else
        if [ "$1" = "python" ]; then
            brew install "${python[@]}"
        else
            if [ "$1" = "cpp" ]; then
                brew install "${cpp[@]}"
            else
                if [ "$1" = "all" ]; then
                    brew install "${core[@]}"
                    brew install "${libs[@]}"
                    brew install "${python[@]}"
                else
                    echo "Usage:"
                    echo "core:      Install core packages"
                    echo "libs:      Install libraries"
                    echo "python:    Install Python (Numpy, Scipy, etc..)"
                    echo "all:       Install all apps"
                    exit 1
                fi
            fi
        fi
    fi
fi

