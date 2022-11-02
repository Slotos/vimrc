lua <<LUA
if vim.fn['pac#loaded']('aerial.nvim') then
  local aerial = require'aerial'

  require("aerial").setup({
    -- Priority list of preferred backends for aerial.
    -- This can be a filetype map (see :help aerial-filetype-map)
    backends = {
      -- This underscore key is the default
      ['_']  = {"lsp", "treesitter", "markdown", "man"},
      ruby = {"treesitter", "lsp"},
    },

    -- A list of all symbols to display. Set to false to display all symbols.
    -- This can be a filetype map (see :help aerial-filetype-map)
    -- To see all available values, see :help SymbolKind
    filter_kind = {
      "Class",
      "Module",
      "Constant",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Method",
      "Struct",
    },
  })

  vim.api.nvim_set_keymap('n', '<localleader>]', '<cmd>AerialToggle!<CR>', {})
  -- Jump forwards/backwards with '{' and '}'
  vim.api.nvim_set_keymap('n', '{', '<cmd>AerialPrev<CR>', {})
  vim.api.nvim_set_keymap('n', '}', '<cmd>AerialNext<CR>', {})
  -- Jump up the tree with '[[' or ']]'
  vim.api.nvim_set_keymap('n', '[[', '', { callback = aerial.prev_up })
  vim.api.nvim_set_keymap('n', ']]', '', { callback = aerial.next_up })

  if vim.fn['pac#loaded']('telescope.nvim') then
    -- Open Telescope list
    require('telescope').load_extension('aerial')
    vim.api.nvim_set_keymap('n', '<localleader>[', '<cmd>Telescope aerial<CR>', {})
  end
end
LUA
