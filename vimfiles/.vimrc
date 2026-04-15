
    set laststatus=2
    set ttimeoutlen=50
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

    let g:lightline = {
        \ 'colorscheme': 'embark',
        \ 'active': {
        \   'left':  [['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified']],
        \   'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype']]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'FugitiveHead'
        \ },
        \ 'tabline':          {'left': [['buffers']], 'right': [['close']]},
        \ 'component_expand': {'buffers': 'lightline#bufferline#buffers'},
        \ 'component_type':   {'buffers': 'tabsel'},
        \ }

    let g:lightline#bufferline#show_number = 1
    let g:lightline#bufferline#unnamed = '[No Name]'

    let g:go_version_warning = 0

  " Markdown settings
    let g:vim_markdown_conceal = 1
    let g:vim_markdown_conceal_code_blocks = 0
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_no_extensions_in_markdown = 1
    set conceallevel=2
    autocmd FileType markdown setlocal conceallevel=2

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
