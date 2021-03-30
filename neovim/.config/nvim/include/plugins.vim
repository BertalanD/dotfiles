" Download the vim-plug plugin manager the recommended way
if ! filereadable(system('echo -n "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent ! curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall
endif

call plug#begin(stdpath('data').'/plugged')

" fancy statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Solarized color scheme
Plug 'altercation/vim-colors-solarized'

" color-code matching brackets
Plug 'tpope/vim-surround'

" in-application file explorer
Plug 'preservim/nerdtree'

" block commenting
Plug 'preservim/nerdcommenter'

" make formatting follow project-specific .editorconfig
Plug 'editorconfig/editorconfig-vim'

" Mostly redundant due to rust-analyzer
Plug 'rust-lang/rust.vim'

" Warning: requires NIGHTLY (0.5) neovim builds!
if has('nvim-0.5')
    Plug 'neovim/nvim-lspconfig'

    " Pop-up completion menu
    Plug 'nvim-lua/completion-nvim'
endif

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" Project fluent localization framework
Plug 'projectfluent/fluent.vim'

Plug 'tpope/vim-fugitive'
call plug#end()

if has('nvim-0.5')
    lua require'lspconfig'.rust_analyzer.setup{on_attach=require'completion'.on_attach}
    lua require'lspconfig'.clangd.setup{on_attach=require'completion'.on_attach}
    lua require'lspconfig'.pyls.setup{on_attach=require'completion'.on_attach}
endif

" Use powerline symbols in status bar
let g:airline_powerline_fonts = 1
