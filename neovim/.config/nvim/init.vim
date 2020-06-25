" Instructions for Arch:
" Install the following packages:
" - vim-airline
" - vim-airline-themes
" - vim-colors-solarized-git (AUR)
" - vim-surround
" - vim-nerdtree
" - vim-editorconfig
" - vim-rainbow-parentheses-git (AUR)

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

" Do not force using a plugin manager if plugin is installed via distro tools
" TODO: clean up with metaprogramming/macro stuff
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
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

set nocompatible
set clipboard+=unnamedplus
filetype plugin on
syntax on
set encoding=utf-8
set number relativenumber
set backspace=indent,eol,start

set background=dark
colorscheme solarized
