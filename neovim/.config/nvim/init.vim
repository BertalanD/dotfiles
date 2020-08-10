" Install plugins first. Files sourced later might configure/depend on them.
runtime! include/plugins.vim

" Language-specific settings
runtime! include/lang.vim

" Custom keymaps (I prefer everything vanilla though)
runtime! include/keybinds.vim

runtime! include/options.vim
