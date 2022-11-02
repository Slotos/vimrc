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
end
