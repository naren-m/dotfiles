filetype plugin indent on
syntax on
set nocompatible
set encoding=utf-8

" Vim Settings
" Source https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.vim/plugin/settings.vim

" Numbering settings
    set number
    set relativenumber

" Indentation settings for using 4 spaces instead of tabs.
    set shiftwidth=4
    set softtabstop=4
    set expandtab
    set autoindent                        " the same indent as the line you're currently on. 
    " Formatting settings
        set formatoptions+=n              " smart auto-indenting inside numbered lists
        if v:version > 703 || v:version == 703 && has('patch541')
          set formatoptions+=j            " remove comment leader when joining comment lines
        endif
" Bell settings
    if exists('&belloff')
      set belloff=all                     " never ring the bell for any reason
    endif

" Show whitespaces settings
    set list                              " show whitespace
    set listchars=nbsp:⦸                  " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
    set listchars+=tab:▷┅                 " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
                                          " + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
    set listchars+=extends:»              " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
    set listchars+=precedes:«             " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
    set listchars+=trail:•                " BULLET (U+2022, UTF-8: E2 80 A2)

" Linebreak settings
    if has('linebreak')
      set linebreak                       " wrap long lines at characters in 'breakat'
      set breakindent                     " indent wrapped lines to match start
        if exists('&breakindentopt')
          set breakindentopt=shift:2      " emphasize broken lines by indenting them
        endif

        let &showbreak='⤷ '               " ARROW POINTING DOWNWARDS THEN CURVING RIGHTWARDS (U+2937, UTF-8: E2 A4 B7)
    endif

" Folding settings
    if has('folding')
      if has('windows')
        let &fillchars='vert: '           " less cluttered vertical window separators
      endif
      set foldmethod=indent               " not as cool as syntax, but faster
      set foldlevelstart=999              " start unfolded
    endif
    " Custom folding
    " Source http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
        fu! CustomFoldText()
            "get first non-blank line
            let fs = v:foldstart
            while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
            endwhile
            if fs > v:foldend
                let line = getline(v:foldstart)
            else
                let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
            endif

            let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
            let foldSize = 1 + v:foldend - v:foldstart
            let foldSizeStr = " " . foldSize . " lines "
            let foldLevelStr = repeat("+--", v:foldlevel)
            let lineCount = line("$")
            let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
            let expansionString = repeat(".", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
            return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
        endf

        set foldtext=CustomFoldText()

" For GUI
    if has("gui_running")
      vmap <C-S-x> "+x
      vmap <C-S-c> "+y
      imap <C-S-v> <Esc>"+gP
    endif

" Mappings
" Toggle fold at current position.
    nnoremap <s-tab> za

" Quicker window movement
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-h> <C-w>h
    nnoremap <C-l> <C-w>l

" Plugins
    " Setting up and starting pathogen
        execute pathogen#infect()

    " Nerd tree toggle
        map <C-n> :NERDTreeToggle<CR>

    " CtrlP for fuzzy file search
        set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

    " Vim-airline
        set laststatus=2
        set ttimeoutlen=10
        let g:airline#extensions#tabline#enabled = 1
        "let g:airline_theme = 'powerlineish'
        let g:airline_theme='simple'
        let g:airline#extensions#hunks#enabled=0
        let g:airline#extensions#branch#enabled=1
        let g:airline_powerline_fonts = 1
        if !exists('g:airline_symbols')
          let g:airline_symbols = {}
        endif
        " Symbols
            let g:airline_symbols.space = "\ua0"
            let g:airline_symbols.linenr = '¶'
            let g:airline_symbols.branch = '⎇'
            let g:airline_symbols.paste = 'Þ'
            let g:airline_symbols.whitespace = 'Ξ'
            " let g:airline_section_b = '%{strftime("%c")}'
            " set ambiwidth=double "The statusline wraps

    " Cscope
        if has("cscope")
            so ~/.vim/bundle/cscope_plugin.vim
        endif
