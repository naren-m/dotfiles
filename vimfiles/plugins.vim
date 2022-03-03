" Plugins
    " Vim-plug
    call plug#begin('~/.vim/plugged')

    " Utility
    " Plug 'junegunn/vim-easy-align'
    " Plug 'honza/vim-snippets'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'rking/ag.vim'

    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'

    " Formatting
    "
    " Caseing
    Plug 'arthurxavierx/vim-caser'

    " True Sublime Text style multiple selections for Vim
    Plug 'terryma/vim-multiple-cursors'

    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'  }

    " Figure out how to use these
    Plug 'tpope/vim-abolish'
    " Plug 'gilsondev/searchtasks.vim'
    " Plug 'mbbill/undotree'                " The ultimate undo history visualizer for VIM
    " Plug 'tpope/vim-repeat'               " enable repeating supported plugin maps with '.'

    " Language helpers
    Plug 'jiangmiao/auto-pairs'
    Plug 'dense-analysis/ale'

    " Bookmarks
    Plug 'MattesGroeger/vim-bookmarks'

    " Tree
    Plug 'preservim/nerdtree'
    Plug 'ryanoasis/vim-devicons'



    " Colors schemes
    Plug 'dolio/vim-hybrid'
    Plug 'morhetz/gruvbox'
    Plug 'chriskempson/base16-vim'
    Plug 'mhartington/oceanic-next'

    Plug 'milkypostman/vim-togglelist'    " Functions to toggle the [Location List] and the [Quickfix List] windows.
    " Plug 'tpope/vim-sleuth'               " automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
    Plug 'tomtom/tcomment_vim'            " comment stuff out (via leader-/)
    Plug 'mhinz/vim-signify'              " Show a diff via Vim sign column.
    Plug 'tpope/vim-fugitive'             " a Git wrapper so awesome, it should be illegal; :Gblame, etc
    Plug 'christoomey/vim-tmux-navigator' " Tmux navigator
    " Plug 'ervandew/supertab'

    " Time tracking
    " Plug 'git-time-metric/gtm-vim-plugin'

    " Documentation search
    " Plug 'rizzatti/dash.vim'

    " Task warrior
    " Plug 'blindFS/vim-taskwarrior'

    " Yang model
    Plug 'nathanalderson/yang.vim'


    " Not using
    " Plug 'tpope/vim-abolish'
    " Plug 'tpope/vim-commentary'
    " Plug 'majutsushi/tagbar'

    " TODO: Add following plugins
    " - https://github.com/tpope/vim-eunuch
    " - https://github.com/tpope/vim-surround
    " - https://github.com/w0rp/ale
    " - https://github.com/mhinz/vim-startify
    " - https://github.com/garbas/vim-snipmate
    " - https://github.com/xolox/vim-notes

	Plug 'lervag/vimtex'
	let g:tex_flavor='latex'
	let g:vimtex_view_method='zathura'
	let g:vimtex_quickfix_mode=0
	set conceallevel=1
	let g:tex_conceal='abdmg'

    call plug#end()
