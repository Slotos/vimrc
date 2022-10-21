if vim.fn['pac#loaded']('rose-pine') then
  require('rose-pine').setup({
    highlight_groups = {
      -- Borderless telescope
      TelescopeBorder = { fg = "overlay", bg = "overlay" },
      TelescopeNormal = { fg = "subtle", bg = "overlay" },
      TelescopePromptNormal = { fg = "text", bg = "overlay" },
      TelescopeSelection = { fg = "text", bg = "highlight_med" },
      TelescopeTitle = { fg = "base", bg = "love" },
      TelescopePromptTitle = { fg = "base", bg = "pine" },
      TelescopePreviewTitle = { fg = "base", bg = "iris" },
    },
  })
end
