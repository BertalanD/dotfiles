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
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export WEECHAT_HOME="${XDG_CONFIG_HOME:-$HOME/.local/share}/weechat"
export CCACHE_CONFIGPATH="${XDG_CONFIG_HOME:-$HOME/.config}/ccache.config"
export CCACHE_DIR="${XDG_CACHE_HOME:-$HOME/.local.share}/ccache"

# use Wayland for everything
if command -v sway >/dev/null; then
    export MOZ_ENABLE_WAYLAND=1
    if command -v qtwaylandscanner >/dev/null; then
        export QT_QPA_PLATFORM=wayland-egl
        # export QT_WAYLAND_FORCE_DPI=physical		# disabled now because Qt apps suck on wayland
    fi
    export CLUTTER_BACKEND=wayland
    export SDL_VIDEODRIVER=wayland
    export ECORE_EVAS_ENGINE=wayland_egl
    export ELM_ENGINE=wayland_egl
    export _JAVA_AWT_WM_NONREPARENTING=1
fi

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
# wofi uses GLib for running desktop files and executes terminal applications
# in the terminal set via gsettings
gsettings set org.gnome.desktop.default-applications.terminal exec "$TERMINAL"
gsettings set org.gnome.desktop.default-applications.terminal exec-arg '-e'
if command -v firefox-developer-edition >/dev/null; then
    export BROWSER="firefox-developer-edition"
elif command -v brave >/dev/null; then
    export BROWSER="brave"
elif command -v firefox >/dev/null; then
    export BROWSER="firefox"
else
    export BROWSER="chromium"
fi
command -v zathura >/dev/null && export READER="zathura"

# Automatically start sway on TTY1
if command -v sway >/dev/null &&  [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1  # only set here in case I want to run weston with client-side decoration
    exec sway
fi
