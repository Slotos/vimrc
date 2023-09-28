if vim.fn['pac#loaded']('rose-pine') then
  local rose_pine_setup_group = vim.api.nvim_create_augroup('RosePineSetup', { clear = true })
  vim.api.nvim_create_autocmd({ 'ColorSchemePre' },
    {
      group = rose_pine_setup_group,
      callback = function(event)
        if string.find(event.match, "rose%-pine") == 1 then
          require('rose-pine').setup({
            highlight_groups = {
              -- Borderless telescope
              TelescopeBorder = { fg = "overlay", bg = "overlay" },
              TelescopeNormal = { fg = "subtle", bg = "overlay" },
              TelescopeSelection = { fg = "text", bg = "highlight_med" },
              TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
              TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },

              TelescopeTitle = { fg = "base", bg = "love" },
              TelescopePromptTitle = { fg = "base", bg = "pine" },
              TelescopePreviewTitle = { fg = "base", bg = "iris" },

              TelescopePromptNormal = { fg = "text", bg = "surface" },
              TelescopePromptBorder = { fg = "surface", bg = "surface" },

              NotifierTitle = { fg = "gold", bg = "overlay" },

              ['@heredoc_content'] = { underdotted = true },

              NeotestAdapterName = { fg = "pine" },
              NeotestBorder = { fg = "overlay", bg = "overlay" },
              NeotestDir = { fg = "muted" },
              NeotestExpandMarker = { fg = "foam" },
              NeotestFailed = { fg = "love" },
              NeotestFile = { fg = "subtle" },
              NeotestFocused = { fg = "text" },
              NeotestIndent = { fg = "iris" },
              NeotestMarked = { fg = "rose" },
              NeotestNamespace = { fg = "pine" },
              NeotestPassed = { fg = "foam" },
              NeotestRunning = { fg = "iris" },
              NeotestWinSelect = { fg = "text", bold = true },
              NeotestSkipped = { fg = "rose", blend = 20 },
              NeotestTarget = { fg = "love", blend = 10 },
              NeotestTest = { fg = "text" },
              NeotestUnknown = { fg = "text" },
              NeotestWatching = { fg = "gold" },
            },
          })

          vim.api.nvim_clear_autocmds({ group = rose_pine_setup_group })
        end
      end,
      desc = 'Setup rose-pine',
    }
  )
end

if vim.fn['pac#loaded']('catppuccin') then
  local catppuccin_setup_group = vim.api.nvim_create_augroup('CatppuccinSetup', { clear = true })
  vim.api.nvim_create_autocmd({ 'ColorSchemePre' },
    {
      group = catppuccin_setup_group,
      callback = function(event)
        if string.find(event.match, "catppuccin") == 1 then
          local telescopeBorderless = function(flavor)
            local cp = require("catppuccin.palettes").get_palette(flavor)

            return {
              TelescopeBorder = { fg = cp.surface0, bg = cp.surface0 },
              TelescopeSelectionCaret = { fg = cp.flamingo, bg = cp.surface1 },
              TelescopeMatching = { fg = cp.peach },
              TelescopeNormal = { bg = cp.surface0 },
              TelescopeSelection = { fg = cp.text, bg = cp.surface1 },
              TelescopeMultiSelection = { fg = cp.text, bg = cp.surface2 },

              TelescopeTitle = { fg = cp.crust, bg = cp.green },
              TelescopePreviewTitle = { fg = cp.crust, bg = cp.red },
              TelescopePromptTitle = { fg = cp.crust, bg = cp.mauve },

              TelescopePromptNormal = { fg = cp.flamingo, bg = cp.crust },
              TelescopePromptBorder = { fg = cp.crust, bg = cp.crust },
            }
          end

          require("catppuccin").setup {
            background = { -- :h background
              light = "latte",
              dark = "mocha",
            },
            term_colors = true,
            dim_inactive = {
              enabled = true
            },
            highlight_overrides = {
              latte = telescopeBorderless('latte'),
              frappe = telescopeBorderless('frappe'),
              macchiato = telescopeBorderless('macchiato'),
              mocha = telescopeBorderless('mocha'),
            },
          }

          vim.api.nvim_clear_autocmds({ group = catppuccin_setup_group })
        end
      end,
      desc = 'Setup catppuccin',
    }
  )
end
