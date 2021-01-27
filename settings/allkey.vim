" insert keymap like emacs
inoremap <expr><C-e> pumvisible() ? "\<C-e>" : "\<End>"

" Write buffer (save)
noremap <Leader>w :w<CR>

"insert a newline
inoremap <C-O> <Esc>o

nnoremap  ]b :bp<CR>
nnoremap  [b :bn<CR>

"switch windw
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

"yank to end
nnoremap Y y$

" settings for resize splitted window
nmap <C-w>[ :vertical resize -3<CR>
nmap <C-w>] :vertical resize +3<CR>

" Remove spaces at the end of lines
nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

" plugin specific mappings
if pac#loaded('coc.nvim')
  " Using CocList
  " Show all diagnostics
  nnoremap <silent> <leader>cd  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
  " Search workspace symbols
  nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <leader>cj  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <leader>ck  :<C-u>CocPrev<CR>
  " Resume latest coc list
  nnoremap <silent> <leader>cr  :<C-u>CocListResume<CR>
  " Use `[c` and `]c` for navigate diagnostics
  nmap <silent> ]c <Plug>(coc-diagnostic-prev)
  nmap <silent> [c <Plug>(coc-diagnostic-next)
  " Remap for rename current word
  nmap <leader>cn <Plug>(coc-rename)
  " Remap for format selected region
  vmap <leader>cf  <Plug>(coc-format-selected)
  nmap <leader>cf  <Plug>(coc-format-selected)
  " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
  xmap <leader>ca  <Plug>(coc-codeaction-selected)
  nmap <leader>ca  <Plug>(coc-codeaction-selected)
  " Remap for do codeAction of current line
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)
  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  " Use K for show documentation in preview window
  nnoremap <silent> K :call <sid>show_documentation()<cr>
  " use <c-space> for trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()
  nmap [g <Plug>(coc-git-prevchunk)
  nmap ]g <Plug>(coc-git-nextchunk)
  " show chunk diff at current position
  nmap gs <Plug>(coc-git-chunkinfo)
  " show commit contains current position
  nmap gm <Plug>(coc-git-commit)
  nnoremap <silent> <leader>cg  :<C-u>CocList --normal gstatus<CR>
  " float window scroll
  nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
  nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
  " multiple cursors session
  nmap <silent> <C-c> <Plug>(coc-cursors-position)
  nmap <silent> <M-c> <Plug>(coc-cursors-word)
  xmap <silent> <M-c> <Plug>(coc-cursors-range)
  nnoremap <silent> <leader>cm ::CocSearch -w 
  " use normal command like `<leader>xi(`
  nmap <leader>x <Plug>(coc-cursors-operator)

  " Explorer
  nnoremap <silent> <Leader>e
        \ :CocCommand explorer<CR> getcwd()
  nnoremap <silent> <Leader>fe
        \ :CocCommand explorer<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocActionAsync('doHover')
    endif
  endfunction
endif

if pac#loaded('fzf.vim')
  nnoremap <silent> <leader>fc :Colors<CR>
  nnoremap <silent> <leader>fb :Buffers<CR>
  nnoremap <silent> <leader>ff :Files<CR>
  nnoremap <silent> <leader>fr :Rg<CR>
  nnoremap <silent> <leader>fw :Rg <C-R><C-W><CR>
endif

if pac#loaded('undotree')
  nnoremap <silent> <localleader>u :UndotreeToggle<CR>
endif

if pac#loaded('neoterm')
  function! ZombieServer()
    if has_key(g:neoterm.instances, g:neoterm.last_active)
      Tkill
    endif
    belowright T live-server '%'
    call g:neoterm.instances[g:neoterm.last_active].normal('G')
  endfunction
  nnoremap <leader>l :call ZombieServer()<CR>
end

if pac#loaded('vim-choosewin')
  nmap -         <Plug>(choosewin)
  nmap <Leader>- :<C-u>ChooseWinSwapStay<CR>
endif

if pac#loaded('vim-expand-region')
  xmap v <Plug>(expand_region_expand)
  xmap V <Plug>(expand_region_shrink)
endif

if pac#loaded('vista.vim')
  nnoremap <silent><localleader>v :Vista<CR>
  nnoremap <silent><leader>fv     :Vista finder coc<CR>
endif

if pac#loaded('vim-easymotion')
  nmap <Leader><Leader>w <Plug>(easymotion-w)
  nmap <Leader><Leader>f <Plug>(easymotion-f)
  nmap <Leader><Leader>b <Plug>(easymotion-b)
endif

if pac#loaded('vim-which-key')
  nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
  nnoremap <silent> <localleader> :<c-u>WhichKey  ';'<CR>
  nnoremap <silent>[              :<c-u>WhichKey  '['<CR>
  nnoremap <silent>]              :<c-u>WhichKey  ']'<CR>
endif

if pac#loaded('vim-localorie')
  nnoremap <silent> <leader>yt :call localorie#translate()<CR>
  nnoremap <silent> <leader>ye :echo localorie#expand_key()<CR>
endif
