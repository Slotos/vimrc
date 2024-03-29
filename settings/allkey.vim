" Write buffer (save)
noremap <silent> <nowait> <Leader>w :w<CR>

"insert a newline
inoremap <C-O> <Esc>o

nnoremap  ]b :bp<CR>
nnoremap  [b :bn<CR>

"switch window
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" settings for resize splitted window
nmap <C-w>[ :vertical resize -3<CR>
nmap <C-w>] :vertical resize +3<CR>

" Remove spaces at the end of lines
nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

if pac#loaded('neo-tree.nvim')
  " Explorer
  nnoremap <silent> <leader>e :Neotree toggle<CR>
  nnoremap <silent> <leader>fe :Neotree reveal<CR>
endif

if pac#loaded('undotree')
  nnoremap <silent> <localleader>u :UndotreeToggle<CR>
endif

if pac#loaded('vim-expand-region')
  xmap v <Plug>(expand_region_expand)
  xmap V <Plug>(expand_region_shrink)
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
    execute 'DiffviewOpen ' . get(a:, 1, 'origin/main') . '...HEAD'
  endfunction
endif

if pac#loaded('venn.nvim')
lua <<LUA
  -- venn.nvim: enable or disable keymappings
  function _G.Toggle_venn()
      local venn_enabled = vim.inspect(vim.b.venn_enabled)
      if venn_enabled == "nil" then
          vim.b.venn_enabled = true
          vim.cmd[[setlocal ve=all]]
          -- draw a line on HJKL keystokes
          vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
          vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
          vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
          vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
          -- draw a box by pressing "f" with visual selection
          vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
      else
          vim.cmd[[setlocal ve=]]
          -- Clean own maps
          vim.api.nvim_buf_del_keymap(0, "n", "J")
          vim.api.nvim_buf_del_keymap(0, "n", "K")
          vim.api.nvim_buf_del_keymap(0, "n", "L")
          vim.api.nvim_buf_del_keymap(0, "n", "H")
          vim.api.nvim_buf_del_keymap(0, "v", "f")
          vim.b.venn_enabled = nil
      end
  end
  -- toggle keymappings for venn using <leader>v
  vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})
LUA
endif

if pac#loaded('nabla.nvim')
  nnoremap <silent> <localleader>; :lua require"nabla".enable_virt()<CR>
  nnoremap <silent> <localleader>n :lua require"nabla".disable_virt()<CR>
endif

" TODO: Check for OSX
" Browse command that opens arguments with system's `open`
" Used by Fugitive's GBrowse
command! -bar -nargs=1 Browse silent! !open <args>
