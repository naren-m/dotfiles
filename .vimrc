filetype plugin indent on
syntax on

if has("gui_running")
  vmap <C-S-x> "+x 
  vmap <C-S-c> "+y 
  imap <C-S-v> <Esc>"+gP
endif

set number

" the same indent as the line you're currently on. 
set autoindent

" Indentation settings for using 4 spaces instead of tabs.
set shiftwidth=4
set softtabstop=4
set expandtab

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Setting up and starting pathogen
execute pathogen#infect()

" Nerd tree toggle
map <C-n> :NERDTreeToggle<CR>

" CtrlP for fuzzy file search
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

" set laststatus=2  " Always display the status line
"
"" Nerdcommenter setup
" Add spaces after comment delimiters by default
" let g:NERDSpaceDelims = 1
" let g:AutoPairsFlyMode = 1

" Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

if has("cscope")
    so ~/.vim/bundle/cscope_plugin.vim
endif
