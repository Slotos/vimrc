lua <<LUA
if vim.fn['pac#loaded']('aerial.nvim') then
  local aerial = require'aerial'

  require("aerial").setup({
    -- Priority list of preferred backends for aerial.
    -- This can be a filetype map (see :help aerial-filetype-map)
    backends = {
      -- This underscore key is the default
      ['_']  = {"lsp", "treesitter", "markdown"},
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

    -- Call this function when aerial attaches to a buffer.
    -- Useful for setting keymaps. Takes a single `bufnr` argument.
    on_attach = function(bufnr)
      -- Toggle the aerial window with <leader>a
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>]', '<cmd>AerialToggle!<CR>', {})
      -- Jump forwards/backwards with '{' and '}'
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '{', '<cmd>AerialPrev<CR>', {})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '}', '<cmd>AerialNext<CR>', {})
      -- Jump up the tree with '[[' or ']]'
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '[[', '<cmd>AerialPrevUp<CR>', {})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', ']]', '<cmd>AerialNextUp<CR>', {})

      if vim.fn['pac#loaded']('telescope.nvim') then
        -- Open Telescope list
        require('telescope').load_extension('aerial')
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<localleader>[', '<cmd>Telescope aerial<CR>', {})
      end
    end,
  })
end
LUA
