#!/bin/sh

# Environmental variables applying to all shells are set here

# Add '~/.local/bin' and its subdirectories to $PATH
mkdir -p "${HOME}/.local/bin"
export PATH="${PATH}:$(du "${HOME}/.local/bin" | cut -f2 | paste -sd ':')"

# Clean up dotfiles
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export GNUPGHOME="${XDG_CONFIG_HOME:-$HOME/.config}/gnupg"
export ENV="${XDG_CONFIG_HOME:-$HOME/.config}/shrc"    # POSIX shell rc
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh" # zshrc
export LESSHISTFILE="-"                                # do not store history
command -v sway >/dev/null && export MOZ_ENABLE_WAYLAND=1

# Program settings
command -v wofi >/dev/null && export SUDO_ASKPASS="$HOME/.local/bin/wofi-askpass"
XDG_PICTURES_DIR="$(xdg-user-dir PICTURES)" 2>/dev/null
export XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
export GRIM_DEFAULT_DIR="$XDG_PICTURES_DIR/screenshots"
mkdir -p "$GRIM_DEFAULT_DIR"

# Default applications.
if command -v nvim >/dev/null; then
    export EDITOR="nvim"
else
    export EDITOR="vim"
fi
export VISUAL="$EDITOR"
command -v alacritty >/dev/null && export TERMINAL="alacritty"
#wofi uses GLib for running desktop files and executes terminal applications
#in the terminal set via gsettings
gsettings set org.gnome.desktop.default-applications.terminal exec "$TERMINAL"
gsettings set org.gnome.desktop.default-applications.terminal exec-arg '-e'
#export BROWSER="firefox-developer-edition"
command -v brave >/dev/null && export BROWSER="brave"
command -v zathura >/dev/null && export READER="zathura"
