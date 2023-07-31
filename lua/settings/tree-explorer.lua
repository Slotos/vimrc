if vim.fn['pac#loaded']('neo-tree.nvim') then
  if vim.fn['pac#loaded']('nvim-window-picker') then
    require'window-picker'.setup({
      -- hint = 'statusline-winbar',
      hint = 'floating-big-letter',
      picker_config = {
        statusline_winbar_picker = {
          use_winbar = "always",
        },
      },
      filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        -- filter using buffer options
        bo = {
          -- if the file type is one of following, the window will be ignored
          filetype = {
            "neo-tree",
            "neo-tree-popup",
            "notify",
            "quickfix",
            "aerial",
            "dapui_scopes",
            "dapui_breakpoints",
            "dapui_stacks",
            "dapui_watches",
            "dapui_console",
            "dap-repl",
            "fugitive",
          },

          -- if the buffer type is one of following, the window will be ignored
          buftype = { 'terminal' },
        },
      },
    })
  end

  vim.g.neo_tree_remove_legacy_commands = 1

  local default_neo_tree_config = require'neo-tree.defaults'
  local neo_tree_config = {
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    window = {
      mappings = {
        ["<2-leftmouse>"] = "open_with_window_picker",
        ["<cr>"] = "open_with_window_picker",
        ["<C-x>"] = "split_with_window_picker",
        ["<C-v>"] = "vsplit_with_window_picker",
        ["<C-t>"] = "open_tabnew",
      },
    },
    filesystem = {
      window = {
        mappings = {
          ["<C-x>"] = "split_with_window_picker",
        }
      }
    }
  }

  require("neo-tree").setup(
    vim.tbl_deep_extend('force', default_neo_tree_config, neo_tree_config)
  )
end
