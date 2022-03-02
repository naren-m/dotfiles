
    set laststatus=2
    set ttimeoutlen=10
    set showtabline=2
    set encoding=UTF-8


    " Call the .plugins.vim file
    if filereadable(expand("~/.plugins.vim"))
        source ~/.plugins.vim
    endif

  " source basic vim
    if filereadable(expand("~/.basic.vim"))
        source ~/.basic.vim
    endif


  " source mappings vim
    if filereadable(expand("~/.mappings.vim"))
        source ~/.mappings.vim
    endif

  " bookmarks plugin
    let g:bookmark_save_per_working_dir = 1
    let g:bookmark_auto_save = 1

    let g:lightline = {}
    let g:lightline.colorscheme = "jellybeans"
    let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
    let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
    let g:lightline.component_type   = {'buffers': 'tabsel'}

    let g:lightline#bufferline#show_number = 1


  " Nerd Tree  
	" Exit Vim if NERDTree is the only window remaining in the only tab.
	autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
	" Close the tab if NERDTree is the only window remaining in it.
	autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
	" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
	autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
	    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

    " Cscope
        if has("cscope")
            source ~/.vim/bundle/cscope_plugin.vim
        endif
