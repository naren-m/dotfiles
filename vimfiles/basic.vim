filetype plugin indent on
syntax on
set nocompatible

" Vim Settings
" Source https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.vim/plugin/settings.vim

set background=dark
colorscheme hybrid

" Find files using find commad
" :find test<tab>
set path+=**

" Display all matching files when we tab complete
" :b lets you autocomplete any open buffer
set wildmenu

" Mappings.
" write file on enter
nnoremap <unique> <expr> <CR> empty(&buftype) ? ':w<CR>' : '<CR>'

" Enable mouse
    set mouse=a

" Copy to clipboard
    set clipboard=unnamed
" Make it obvious where 80 characters is
    set textwidth=80
    set colorcolumn=+1
    let &colorcolumn=join(range(81,999),",")  "for having shadedline after 80
    highlight ColorColumn ctermbg=235 guibg=#2c2d27
    highlight LineNr ctermfg=grey
    let &colorcolumn="80,".join(range(999,999),",")

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
    " when indenting with '>', use 4 spaces width
    set shiftwidth=4
    set softtabstop=4
    " show existing tab with 4 spaces width
    set tabstop=4
    " On pressing tab, insert 4 spaces
    set expandtab
    set autoindent                        " the same indent as the line you're currently on.

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
      " set breakindent                     " indent wrapped lines to match start
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

   " Remapping leader
    let g:mapleader=','
    let g:maplocalleader = '-'
    "    let mapleader=","


    " CtrlP for fuzzy file search
        set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
