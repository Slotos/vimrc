lua <<LUA
if vim.fn['pac#loaded']('telescope.nvim') then
  local telescope = require('telescope')

  if vim.fn['pac#loaded']('telescope-fzf-native.nvim') then
    telescope.load_extension('fzf')
  end

  if vim.fn['pac#loaded']('telescope-lsp-handlers.nvim') then
    telescope.load_extension('lsp_handlers')
  end

  if vim.fn['pac#loaded']('trouble.nvim') then
    local trouble = require("trouble.providers.telescope")

    telescope.setup {
      defaults = {
        mappings = {
          i = { ["<c-q>"] = trouble.open_with_trouble },
          n = { ["<c-q>"] = trouble.open_with_trouble },
          },
        },
      }
  end
end
LUA
