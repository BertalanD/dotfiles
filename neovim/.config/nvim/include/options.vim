" show relative line number
set number relativenumber

" keep cursor 5 lines from top/bottom
set scrolloff=5

" let neovim not be vi
set nocompatible

" expected behavior (delete indents and line breaks)
set backspace=indent,eol,start

" enable syntax highlighting
filetype plugin on
syntax enable

" use '+' buffer for system clipboard
set clipboard+=unnamed

" display symbol for whitespace characters (do :set list)
set listchars=eol:⏎,tab:--⇥,trail:·,nbsp:⎵

" do not show mode in command line b/c airline does it
set noshowmode

" set terminal title
set title

" color scheme
set background=dark
colorscheme solarized

" completion-nvim options
"
" Completion menu: show even if only 1 match, insert on <CR> etc.
set completeopt=menuone,noinsert,noselect
set shortmess+=c

set mouse=a
