
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


    " Vim-airline
        set laststatus=2
        set ttimeoutlen=10
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#hunks#enabled=0
        let g:airline#extensions#branch#enabled=1
        let g:airline_powerline_fonts = 1
        let g:airline_extensions = []
        let g:airline_highlighting_cache = 1

        if !exists('g:airline_symbols')
          let g:airline_symbols = {}
        endif
        " Symbols
            let g:airline_symbols.space = "\ua0"
            let g:airline_symbols.linenr = '¶'
            let g:airline_symbols.branch = '⎇'
            let g:airline_symbols.paste = 'Þ'
            let g:airline_symbols.whitespace = 'Ξ'

    " Cscope
        if has("cscope")
            source ~/.vim/bundle/cscope_plugin.vim
        endif
