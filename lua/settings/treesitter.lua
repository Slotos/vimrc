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
      enable = true,
    },
    endwise = {
      enable = true,
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      },
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = {"BufWrite", "CursorHold"},
    },
    rainbow = {
      enable = true,
      extended_mode = true,
    },
  }

  vim.api.nvim_create_augroup('TreeSitterFolds', { clear = true })
  vim.api.nvim_create_autocmd({ 'FileType' },
    {
      pattern = 'ruby,eruby,javascript,lua,go,elixir,vim',
      group = 'TreeSitterFolds',
      callback = function()
        vim.opt_local.foldmethod = 'expr'
        vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
      end,
      desc = 'Set tree-sitter folding for chosen filetypes',
    }
  )

  vim.api.nvim_set_keymap('n', '<leader>h', ":TSHighlightCapturesUnderCursor<CR>", { silent = true })
end

if vim.fn['pac#loaded']('nvim-treesitter-context') then
  require'treesitter-context'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
      -- For all filetypes
      -- Note that setting an entry here replaces all other patterns for this entry.
      -- By setting the 'default' entry below, you can control which nodes you want to
      -- appear in the context window.
      ruby = {
        'block',
        'elsif',
        'module',
        'when',
      },
      lua = {
        'elseif_statement',
        'else_statement',
      },
      html = {
        'element',
      },
    },
  }
end

if vim.fn['pac#loaded']('nvim-treesitter-textobjects') then
  require'nvim-treesitter.configs'.setup {
    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          ["af"] = { query = "@function.outer", desc = "Select outer part of a function region"},
          ["if"] = { query = "@function.inner", desc = "Select inner part of a function region"},
          ["ac"] = { query = "@class.outer", desc = "Selct outer part of a class region"},
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          ["ap"] = { query = "@parameter.outer", desc = "Selct outer part of a parameter region"},
          ["ip"] = { query = "@parameter.inner", desc = "Select inner part of a parameter region" },
          ["ab"] = { query = "@block.outer", desc = "Selct outer part of a block region"},
          ["ib"] = { query = "@block.inner", desc = "Select inner part of a block region" },
        },
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        -- include_surrounding_whitespace = true,
      },
      swap = {
        enable = true,
        swap_next = {
          ["<localleader>p"] = "@parameter.inner",
          ["<localleader>m"] = "@function.outer",
        },
        swap_previous = {
          ["<localleader>P"] = "@parameter.inner",
          ["<localleader>M"] = "@function.outer",
        },
      },
    },
  }
end
