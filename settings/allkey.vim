" insert keymap like emacs
inoremap <expr><C-e> pumvisible() ? "\<C-e>" : "\<End>"

" Write buffer (save)
noremap <silent> <nowait> <Leader>w :w<CR>

"insert a newline
inoremap <C-O> <Esc>o

nnoremap  ]b :bp<CR>
nnoremap  [b :bn<CR>

"switch windw
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" settings for resize splitted window
nmap <C-w>[ :vertical resize -3<CR>
nmap <C-w>] :vertical resize +3<CR>

" Remove spaces at the end of lines
nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

if pac#loaded('indent-blankline.nvim')
  nnoremap <silent> <localleader>i :IndentBlanklineToggle<CR>
endif

if pac#loaded('neo-tree.nvim')
  " Explorer
  nnoremap <silent> <leader>e :Neotree toggle<CR>
  nnoremap <silent> <leader>fe :Neotree reveal<CR>
endif

if pac#loaded('telescope.nvim')
  nnoremap <silent> <leader>fc :Telescope colorscheme theme=get_dropdown<CR>
  nnoremap <silent> <leader>fb :Telescope buffers ignore_current_buffer=true sort_mru=true theme=get_dropdown<CR>
  nnoremap <silent> <leader>ff :Telescope find_files<CR>
  nnoremap <silent> <leader>fw :Telescope grep_string<CR>
  nnoremap <silent> <leader>fr :Telescope resume<CR>
  nnoremap <silent> <leader>fs :Telescope lsp_dynamic_workspace_symbols<CR>
  command! -nargs=1 Rg execute 'Telescope grep_string use_regex=true search=' . substitute("<args>", ' ', '\\ ', 'g')
endif

if pac#loaded('undotree')
  nnoremap <silent> <localleader>u :UndotreeToggle<CR>
endif

if pac#loaded('vim-choosewin')
  nmap -         <Plug>(choosewin)
  nmap <Leader>- :<C-u>ChooseWinSwapStay<CR>
endif

if pac#loaded('vim-expand-region')
  xmap v <Plug>(expand_region_expand)
  xmap V <Plug>(expand_region_shrink)
endif

if pac#loaded('vim-localorie')
  nnoremap <silent> <leader>yt :call localorie#translate()<CR>
  nnoremap <silent> <leader>ye :echo localorie#expand_key()<CR>
endif

if pac#loaded('vim-dadbod-ui')
  nnoremap <silent> <leader>du :DBUIToggle<CR>
  nnoremap <silent> <leader>df :DBUIFindBuffer<CR>
  nnoremap <silent> <leader>dr :DBUIRenameBuffer<CR>
  nnoremap <silent> <leader>dl :DBUILastQueryInfo<CR>
endif

if pac#loaded('diffview.nvim')
  command! -nargs=? Greview call s:greview(<f-args>)
  function! s:greview(...)
    let origin = trim(execute('Git merge-base -a HEAD ' . get(a:, 1, 'origin/master')))
    execute 'DiffviewOpen ' . origin . '..HEAD'
  endfunction
endif

" TODO: Check for OSX
" Browse command that opens arguments with system's `open`
" Used by Fugitive's GBrowse
command! -bar -nargs=1 Browse silent! !open <args>
