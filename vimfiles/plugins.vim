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


    Plug 'tpope/vim-abolish'               " Case-preserving search/replace (:S/foo/bar/g)
    Plug 'tpope/vim-surround'              " Change/add/delete surrounding chars (cs'\" ds\" ysiw])
    Plug 'tpope/vim-repeat'                " Enable . repeat for plugin actions (surround, etc.)
    Plug 'mbbill/undotree'                 " Visual undo history tree

    " Language helpers
    Plug 'jiangmiao/auto-pairs'
    Plug 'dense-analysis/ale'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'  }

    " Bookmarks
    Plug 'MattesGroeger/vim-bookmarks'

    " Tree
    Plug 'preservim/nerdtree'
    Plug 'ryanoasis/vim-devicons'


    " Markdown
    Plug 'godlygeek/tabular'
    Plug 'preservim/vim-markdown'
    Plug 'dhruvasagar/vim-table-mode'

    " Color schemes
    Plug 'tomasiser/vim-code-dark'
    Plug 'embark-theme/vim', { 'as': 'embark' }
    Plug 'dracula/vim', { 'as': 'dracula' }
    Plug 'sonph/onehalf', { 'rtp': 'vim'  }


    " Tmux
    Plug 'christoomey/vim-tmux-navigator' " Tmux navigator

    Plug 'milkypostman/vim-togglelist'    " Functions to toggle the [Location List] and the [Quickfix List] windows.
    Plug 'tpope/vim-sleuth'               " automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file

    " Git Stuff
    Plug 'mhinz/vim-signify'              " Show a diff via Vim sign column.
    Plug 'tpope/vim-fugitive'             " a Git wrapper so awesome, it should be illegal; :Gblame, etc

    Plug 'ervandew/supertab'

    " Documentation search
    Plug 'rizzatti/dash.vim'

    " Task warrior
    " Plug 'blindFS/vim-taskwarrior'

    " Yang model
    Plug 'nathanalderson/yang.vim'


    Plug 'tomtom/tcomment_vim'            " comment stuff out (via leader-/)
    Plug 'tpope/vim-eunuch'               " Unix helpers (:Rename, :Delete, :Move, :Chmod, :SudoWrite)
    Plug 'mhinz/vim-startify'             " Start screen with recent files and sessions
    Plug 'preservim/tagbar'               " Code outline sidebar (functions, structs, methods)

    call plug#end()
