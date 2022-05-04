if vim.fn['pac#loaded']('telescope.nvim') then
  local telescope = require('telescope')

  if vim.fn['pac#loaded']('telescope-fzf-native.nvim') then
    telescope.load_extension('fzf')
  end

  if vim.fn['pac#loaded']('trouble.nvim') then
    local trouble = require("trouble.providers.telescope")

    telescope.setup {
      defaults = {
        mappings = {
          i = { ["<c-q>"] = trouble.smart_open_with_trouble },
          n = { ["<c-q>"] = trouble.smart_open_with_trouble },
        },
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
      }
    }
  end
end
