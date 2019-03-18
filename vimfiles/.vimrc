
    set laststatus=2
    set ttimeoutlen=10
    set showtabline=2


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

    let g:lightline = {}
    let g:lightline.colorscheme = "jellybeans"
    let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
    let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
    let g:lightline.component_type   = {'buffers': 'tabsel'}

    let g:lightline#bufferline#show_number = 1



    " Cscope
        if has("cscope")
            source ~/.vim/bundle/cscope_plugin.vim
        endif
