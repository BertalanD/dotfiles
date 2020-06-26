" Instructions for Arch:
" Install the following packages:
" - vim-airline
" - vim-airline-themes
" - vim-colors-solarized-git (AUR)
" - vim-surround
" - vim-nerdtree
" - vim-editorconfig
" - vim-rainbow-parentheses-git (AUR)

" Download the vim-plug plugin manager the recommended way
if ! filereadable(system('echo -n "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent ! curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall
endif

" Do not force using a plugin manager if plugin is installed via distro tools
" TODO: clean up with metaprogramming/macro stuff
call plug#begin(stdpath('data') . '/plugged')
if ! &runtimepath =~ 'vim-airline'
    Plug 'vim-airline/vim-airline'
endif
if ! &runtimepath =~ 'vim-airline-themes'
    Plug 'vim-airline/vim-airline-themes'
endif
if ! &runtimepath =~ 'vim-surround'
    Plug 'tpope/vim-surround'
endif
if ! &runtimepath =~ 'nerdtree'
    Plug 'preservim/nerdtree'
endif
if ! &runtimepath =~ 'editorconfig-vim'
    Plug 'editorconfig/editorconfig-vim'
endif
call plug#end()

set nocompatible                            " do not limit features to be vi-compatible
set title                                   " set title of terminal/window
set clipboard+=unnamedplus                  " suffix copy commands with '+' to use system clipboard
set listchars=eol:⏎,tab:--⇥,trail:·,nbsp:⎵  " symbol for whitespace characters (do :set list)
filetype plugin on                          " filetype autodetection and plugin loading
syntax enable                               " enable syntax highlighting, use custom colors
set encoding=utf-8                          " de facto encoding of the modern web
set number relativenumber                   " display line numbers relative to current
set backspace=indent,eol,start              " expected backspace behavior (delete indents, newlines)

set background=dark                         " use dark color scheme version
colorscheme solarized                       " use solarized colors even if terminal does not use it
