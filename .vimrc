filetype plugin indent on
syntax on
set nocompatible

" colorscheme monokai

" Vim Settings
" Source https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.vim/plugin/settings.vim

" Copy to clipboard
    set clipboard=unnamed
" Make it obvious where 80 characters is
    set textwidth=80
    set colorcolumn=+1
    let &colorcolumn=join(range(81,999),",")  "for having shadedline after 80
    highlight ColorColumn ctermbg=235 guibg=#2c2d27
    let &colorcolumn="80,".join(range(120,999),",")

" Numbering settings
    set number
    " set relativenumber
    "Toggle relative numbering, and set to absolute on loss of focus or insert mode
    function! ToggleNumbersOn()
        set nu!
        set rnu
    endfunction
    function! ToggleRelativeOn()
        set rnu!
        set nu
    endfunction
    map <C-r> :call ToggleRelativeOn()<CR>

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
    set listchars+=tab:➝\                 " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
                                          " + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
    set listchars+=extends:»              " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
    set listchars+=precedes:«             " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
    set listchars+=trail:•                " BULLET (U+2022, UTF-8: E2 80 A2)
    hi NonText ctermfg=red guifg=gray


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

" Cycle between buffers
    nnoremap <Tab> :bnext<CR>
    nnoremap <S-Tab> :bprevious<CR>

" Plugins
    " Setting up and starting pathogen
        execute pathogen#infect()

    " Go plugin
       " vim-go
       let g:go_fmt_command = "goimports"
       let g:go_autodetect_gopath = 1
       let g:go_list_type = "quickfix"

       let g:go_highlight_types = 1
       let g:go_highlight_fields = 1
       let g:go_highlight_functions = 1
       let g:go_highlight_methods = 1
       let g:go_highlight_extra_types = 1
       let g:go_highlight_generate_tags = 1

       " Open :GoDeclsDir with ctrl-g
       nmap <C-g> :GoDeclsDir<cr>
       imap <C-g> <esc>:<C-u>GoDeclsDir<cr>

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
