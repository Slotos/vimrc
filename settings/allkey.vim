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

if pac#loaded('nvim-lspconfig')
  " Too lazy to translate this to vimscript
  lua << LUA
  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
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
  function! s:PrepareRgString(query)
    let l:result = a:query

    " Escape single quote
    let l:result = substitute(l:result, "'", "\\'", 'g')
    " Escape backslash
    let l:result = substitute(l:result, '\\', '\\\\', 'g')

    return l:result
  endfunction
  nnoremap <silent> <leader>fc :Telescope colorscheme theme=get_dropdown<CR>
  nnoremap <silent> <leader>fb :Telescope buffers ignore_current_buffer=true sort_mru=true theme=get_dropdown<CR>
  nnoremap <silent> <leader>ff :Telescope find_files<CR>
  nnoremap <silent> <leader>fw :Telescope grep_string<CR>
  nnoremap <silent> <leader>fr :Telescope resume<CR>
  nnoremap <silent> <leader>fs :Telescope lsp_dynamic_workspace_symbols<CR>
  command! -nargs=+ Rg execute 'lua require(''telescope.builtin'').grep_string({ search = ''' . s:PrepareRgString(<q-args>) . ''' })'
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

if pac#loaded('vim-localorie')
  nnoremap <silent> <leader>yt :call localorie#translate()<CR>
  nnoremap <silent> <leader>ye :echo localorie#expand_key()<CR>
endif
