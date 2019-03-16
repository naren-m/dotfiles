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


    " Window Splitting
        nmap <silent> <leader>hs :split<CR>
        nmap <silent> <leader>vs :vsplit<CR>
        nmap <silent> <leader>sc :close<CR>



    let g:gtm_plugin_status_enabled = 1


" For GUI
    if has("gui_running")
      vmap <C-S-x> "+x
      vmap <C-S-c> "+y
      imap <C-S-v> <Esc>"+gP
    endif

" Plugin mappings

    " Mappings
    "
    " vim-easy-align
        " Start interactive EasyAlign in visual mode (e.g. vipga)
        xmap ga <Plug>(EasyAlign)

        " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)

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

    " Commentary.vim
        let g:commentary_map_backslash = 0
        nmap <Leader>ci <Plug>CommentaryLine
        xmap <Leader>ci <Plug>Commentary

        nmap <Leader>/ <Plug>CommentaryLine
        xmap <Leader>/ <Plug>Commentary