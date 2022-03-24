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

if pac#loaded('nvim-lspconfig')
  " Too lazy to translate this to vimscript
  lua << LUA
  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts) -- mnemonic: LSP add
  vim.api.nvim_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts) -- LSP remove
  vim.api.nvim_set_keymap('n', '<leader>ll', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts) -- LSP list
  vim.api.nvim_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<localleader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
LUA
endif

if pac#loaded('indent-blankline.nvim')
  nnoremap <silent> <localleader>i :IndentBlanklineToggle<CR>
endif

if pac#loaded('nvim-tree.lua')
  " Explorer
  nnoremap <silent> <leader>e :NvimTreeToggle<CR>
  nnoremap <silent> <leader>fe :NvimTreeFindFile<CR>
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
