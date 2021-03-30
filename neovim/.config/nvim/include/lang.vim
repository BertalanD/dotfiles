set encoding=utf-8

autocmd FileType rust
    \ setlocal omnifunc=v:lua.vim.lsp.omnifunc

let g:rustfmt_autosave_if_config_present = 1

autocmd FileType markdown
    \ setlocal spell            " enable spell checking (set language with :set spelllang)
    \ | setlocal textwidth=72   " force 72 column wrap (see https://useplaintext.email)

autocmd FileType cpp
    \ setlocal ts=2 sts=2 sw=2 expandtab

autocmd FileType gitcommit
    \ setlocal spell
    \ | setlocal textwidth=72

autocmd FileType mail
    \ setlocal spell
    \ | setlocal textwidth=72

autocmd FileType text
    \ setlocal textwidth=72
