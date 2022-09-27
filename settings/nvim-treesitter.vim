lua <<LUA
if vim.fn['pac#loaded']('nvim-treesitter') then
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
    },
    matchup = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
    },
    indent = {
      enable = true
    },
    endwise = {
      enable = true,
    },
  }

  vim.api.nvim_command('augroup RubyTreeSitterFold')
  vim.api.nvim_command('au!')
  vim.api.nvim_command('autocmd FileType ruby,eruby setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()')
  vim.api.nvim_command('augroup END')

  vim.api.nvim_command('augroup JsTreeSitterFold')
  vim.api.nvim_command('au!')
  vim.api.nvim_command('autocmd FileType javascript setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()')
  vim.api.nvim_command('augroup END')

  vim.api.nvim_set_keymap('n', '<leader>h', ":TSHighlightCapturesUnderCursor<CR>", {silent=true})
end
LUA
