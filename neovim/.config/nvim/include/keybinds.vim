" write current file with `sudo`
command! W w !sudo tee % > /dev/null

" Use <Tab> and <S-Tab> to navigate through popup menu (completion)
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
