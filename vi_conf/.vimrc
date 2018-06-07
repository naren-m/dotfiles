filetype plugin indent on
syntax on
set nocompatible

" Vim Settings
" Source https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.vim/plugin/settings.vim

set background=dark
colorscheme hybrid

" Copy to clipboard
    set clipboard=unnamed
" Make it obvious where 80 characters is
    set textwidth=80
    set colorcolumn=+1
    let &colorcolumn=join(range(81,999),",")  "for having shadedline after 80
    highlight ColorColumn ctermbg=235 guibg=#2c2d27
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

    " Remapping leader
    let g:mapleader=','
    let g:maplocalleader = '-'
    "    let mapleader=","

    " Window Splitting
        nmap <silent> <leader>hs :split<CR>
        nmap <silent> <leader>vs :vsplit<CR>
        nmap <silent> <leader>sc :close<CR>

" Plugins
    " Vim-plug
    call plug#begin('~/.vim/plugged')

    Plug 'junegunn/vim-easy-align'
    Plug 'honza/vim-snippets'
    Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    Plug 'fatih/vim-go', { 'tag': '*' }
    Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'majutsushi/tagbar'
    Plug 'tpope/vim-commentary'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'rking/ag.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    Plug 'dolio/vim-hybrid'
    Plug 'morhetz/gruvbox'
    Plug 'chriskempson/base16-vim'
    Plug 'mhartington/oceanic-next'


    " Functions to toggle the [Location List] and the [Quickfix List] windows.
    Plug 'milkypostman/vim-togglelist'

    " True Sublime Text style multiple selections for Vim
    Plug 'terryma/vim-multiple-cursors'

    " The ultimate undo history visualizer for VIM
    Plug 'mbbill/undotree'

    " enable repeating supported plugin maps with '.'
    Plug 'tpope/vim-repeat'

    " automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
    Plug 'tpope/vim-sleuth'

    " pairs of handy bracket mappings; e.g. [<Space> and ]<Space> add newlines before and after the cursor line
    Plug 'tpope/vim-unimpaired'

    " comment stuff out (via leader-/)
    Plug 'tomtom/tcomment_vim'

    " Show a diff via Vim sign column.
    Plug 'mhinz/vim-signify'

    " a Git wrapper so awesome, it should be illegal; :Gblame, etc
    Plug 'tpope/vim-fugitive'

    call plug#end()

    " Mappings
    "
    " vim-easy-align
        " Start interactive EasyAlign in visual mode (e.g. vipga)
        xmap ga <Plug>(EasyAlign)

        " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)

    " Go plugin
       " vim-go
       let g:go_fmt_command             = "goimports"
       let g:go_autodetect_gopath       = 1
       let g:go_list_type               = "quickfix"
       let g:go_highlight_types         = 1
       let g:go_highlight_fields        = 1
       let g:go_highlight_functions     = 1
       let g:go_highlight_methods       = 1
       let g:go_highlight_extra_types   = 1
       let g:go_highlight_generate_tags = 1

       " " Open :GoDeclsDir with ctrl-g
       nmap <C-g> :GoDeclsDir<cr>
       imap <C-g> <esc>:<C-u>GoDeclsDir<cr>

    " Ag.vim
       " let g:ag_prg="/users/nmudivar/software/bin/ag --column"
       nnoremap <leader>k :exe 'Ag!' expand('<cword>')<cr>


    " fzf.vim
        function! s:buflist()
          redir => ls
          silent ls
          redir END
          return split(ls, '\n')
        endfunction

        function! s:bufopen(e)
          execute 'buffer' matchstr(a:e, '^[ 0-9]*')
        endfunction

        nnoremap <C-p>      : Files<cr>
        nnoremap <leader>f  : Files<cr>
        nnoremap <leader>h  : History<cr>
        nnoremap <leader>bt : BTags<cr>
        nnoremap <leader>bl : BLines<cr>
        nnoremap <leader>tt : Tags<cr>
        nnoremap <leader>b  : Buffers<cr>
        nnoremap <leader>c  : Colors<cr>

    " Nerd tree toggle
        nnoremap <leader>nn :NERDTreeToggle<CR>
        nnoremap \ :NERDTreeToggle<CR>
        nnoremap <leader>nf :NERDTreeFind<CR>
        let g:NERDTreeShowBookmarks=1
        let g:NERDTreeChDirMode=2 " Change the NERDTree directory to the root
        let g:NERDTreeHijackNetrw=0

    " Commentary.vim
        let g:commentary_map_backslash = 0
        nmap <Leader>ci <Plug>CommentaryLine
        xmap <Leader>ci <Plug>Commentary

        nmap <Leader>/ <Plug>CommentaryLine
        xmap <Leader>/ <Plug>Commentary

    " CtrlP for fuzzy file search
        set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

    " Tagbar
        nmap <leader>t :TagbarToggle<CR>
        nmap <leader>tf :TagbarOpen fj<CR>

    " Vim-airline
        set laststatus=2
        set ttimeoutlen=10
        let g:airline#extensions#tabline#enabled = 1
        " let g:airline_theme = 'powerlineish'
        " let g:airline_theme='simple'
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
            source ~/.vim/bundle/cscope_plugin.vim
        endif
