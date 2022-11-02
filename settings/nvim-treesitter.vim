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
LUA
