local uv = vim.uv or vim.loop

if vim.fn['pac#loaded']('rose-pine') then
  local rose_pine_setup_group = vim.api.nvim_create_augroup('RosePineSetup', { clear = true })
  vim.api.nvim_create_autocmd({ 'ColorSchemePre' },
    {
      group = rose_pine_setup_group,
      pattern = "rose-pine*",
      once = true,
      callback = function(event)
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
          dim_nc_background = true,
          dark_variant = 'moon',
        })
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
      pattern = "catppuccin*",
      once = true,
      callback = function(event)
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

        require('catppuccin').setup {
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
          integrations = {
            aerial = true,
          },
        }
      end,
      desc = 'Setup catppuccin',
    }
  )
end

if vim.env.TERM == 'xterm-kitty' then
  local kitty_colors_group = vim.api.nvim_create_augroup('KittyRainbow', { clear = true })

  local create_kitty_callbacks = function()
    vim.api.nvim_create_autocmd({ 'ColorScheme' },
      {
        group = kitty_colors_group,
        pattern = "catppuccin*",
        callback = function(event)
          uv.spawn("kitty", { args = { "+kitten", "themes", "Catppuccin-" .. require('catppuccin').flavour } })
        end,
        desc = 'Sync kitty to vim for catppuccin',
      }
    )

    vim.api.nvim_create_autocmd({ 'ColorScheme' },
      {
        group = kitty_colors_group,
        pattern = "rose-pine*",
        callback = function(event)
          local theme_name = "Rosé Pine"

          if vim.o.background == "light" then
            theme_name = theme_name .. " Dawn"
          elseif string.lower(require('rose-pine.config').options.dark_variant) == 'moon' then
            theme_name = theme_name .. " Moon"
          end

          uv.spawn("kitty", { args = { "+kitten", "themes", theme_name } })
        end,
        desc = 'Sync kitty to vim for rose-pine',
      }
    )
  end

  if vim.v.vim_did_enter == 1 then
    create_kitty_callbacks()
  else
    vim.api.nvim_create_autocmd({ 'ColorScheme' },
      {
        group = kitty_colors_group,
        once = true,
        callback = create_kitty_callbacks
      }
    )
  end
end
