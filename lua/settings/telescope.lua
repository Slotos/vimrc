if vim.fn['pac#loaded']('telescope.nvim') then
  local telescope = require('telescope')
  local config = {
    defaults = {
      mappings = {
        i = {
          ["<Esc>"] = require('telescope.actions').close
        }
      },
      prompt_prefix = "   ",
      entry_prefix = "  ",
      selection_caret = "  ",
    },
    pickers = {
      buffers = {
        show_all_buffers = true,
        sort_lastused = true,
        mappings = {
          i = {
            ["<c-d>"] = "delete_buffer",
          }
        }
      }
    },
  }

  if vim.fn['pac#loaded']('telescope-fzf-native.nvim') then
    telescope.load_extension('fzf')
  end

  if vim.fn['pac#loaded']('trouble.nvim') then
    local trouble = require("trouble.providers.telescope")
    config = vim.tbl_deep_extend(
      'force',
      config,
      {
        defaults = {
          mappings = {
            i = { ["<c-q>"] = trouble.smart_open_with_trouble },
            n = { ["<c-q>"] = trouble.smart_open_with_trouble },
          }
        }
      }
    )
  end

  telescope.setup(config)

  local silentNoremap = function(mode, lhs, rhs, opts)
    vim.keymap.set(
      mode,
      lhs,
      rhs,
      vim.tbl_deep_extend('keep', { noremap = true, silent = true }, opts)
    )
  end
  local get_dropdown = require('telescope.themes').get_dropdown
  local telescope_builtin = require('telescope.builtin')

  silentNoremap('n', '<leader>fc', function() telescope_builtin.colorscheme(get_dropdown({})) end,
    { desc = 'Show telescope colorscheme picker' })
  silentNoremap('n', '<leader>fb',
    function() telescope_builtin.buffers(get_dropdown({ ignore_current_buffer = true, sort_mru = true })) end,
    { desc = 'Show telescope buffer picker' })
  silentNoremap('n', '<leader>ff', function() telescope_builtin.find_files() end,
    { desc = 'Show telescope file finder' })
  silentNoremap('n', '<leader>fw', function() telescope_builtin.grep_string() end,
    { desc = 'Search for string under cursor with telescope' })
  silentNoremap('n', '<leader>fr', function() telescope_builtin.resume() end,
    { desc = 'Show last telescope results window' })
  silentNoremap('n', '<leader>fs', function() telescope_builtin.lsp_dynamic_workspace_symbols() end,
    { desc = 'Show telescope LSP dynamic workspace symbols' })
  vim.api.nvim_create_user_command(
    'Rg',
    function(opts)
      telescope_builtin.grep_string({ use_regex = true, search = opts.args })
    end,
    { nargs = 1 }
  )
end
