if vim.fn['pac#loaded']('rose-pine') then
  require('rose-pine').setup({
    highlight_groups = {
      -- Borderless telescope
      TelescopeBorder = { fg = "overlay", bg = "overlay" },
      TelescopeNormal = { fg = "subtle", bg = "overlay" },
      TelescopeSelection = { fg = "text", bg = "highlight_med" },

      TelescopeTitle = { fg = "base", bg = "love" },
      TelescopePromptTitle = { fg = "base", bg = "pine" },
      TelescopePreviewTitle = { fg = "base", bg = "iris" },

      TelescopePromptNormal = { fg = "text", bg = "surface" },
      TelescopePromptBorder = { fg = "surface", bg = "surface" },
    },
  })
end

if vim.fn['pac#loaded']('catppuccin') then
  (function()
    local telescopeBorderless = function (flavor)
      local cp = require("catppuccin.palettes").get_palette(flavor)

      return {
        TelescopeBorder = { fg = cp.surface0, bg = cp.surface0 },
        TelescopeSelectionCaret = { fg = cp.flamingo },
        TelescopeMatching = { fg = cp.peach },
        TelescopeNormal = { bg = cp.surface0 },
        TelescopeSelection = { fg = cp.text, bg = cp.surface1 },

        TelescopeTitle = { fg = cp.crust, bg = cp.green },
        TelescopePreviewTitle = { fg = cp.crust, bg = cp.red },
        TelescopePromptTitle = { fg = cp.crust, bg = cp.mauve },

        TelescopePromptNormal = { fg = cp.flamingo, bg = cp.crust },
        TelescopePromptBorder = { fg = cp.crust, bg = cp.crust},
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
  end)()
end
