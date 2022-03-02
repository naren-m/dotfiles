" Plugins
    " Vim-plug
    call plug#begin('~/.vim/plugged')

    " Utility
    " Plug 'junegunn/vim-easy-align'
    " Plug 'honza/vim-snippets'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " Plug 'majutsushi/tagbar'
    " Plug 'tpope/vim-commentary'
    Plug 'rking/ag.vim'

    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'

    " True Sublime Text style multiple selections for Vim
    Plug 'terryma/vim-multiple-cursors'

    " Figure out how to use these
    Plug 'tpope/vim-abolish'
    " Plug 'gilsondev/searchtasks.vim'
    " Plug 'mbbill/undotree'                " The ultimate undo history visualizer for VIM
    " Plug 'tpope/vim-repeat'               " enable repeating supported plugin maps with '.'

    " Language helpers
    Plug 'jiangmiao/auto-pairs'

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

    " TODO: Add following plugins
    " - https://github.com/tpope/vim-eunuch
    " - https://github.com/tpope/vim-surround
    " - https://github.com/w0rp/ale
    " - https://github.com/mhinz/vim-startify
    " - https://github.com/garbas/vim-snipmate
    " - https://github.com/xolox/vim-notes


    call plug#end()
