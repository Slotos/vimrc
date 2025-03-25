vim.diagnostic.config({
  virtual_text = false,
})
vim.keymap.set(
  "",
  "<Leader>ld",
  function()
    vim.diagnostic.config({
      virtual_text = vim.diagnostic.config().virtual_lines,
      virtual_lines = not vim.diagnostic.config().virtual_lines,
    })
  end,
  { desc = "Toggle lsp_lines" }
)

local keymap_opts = { noremap = true, silent = true, }

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, keymap_opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, keymap_opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, keymap_opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, keymap_opts)
