if vim.fn['pac#loaded']('notifier.nvim') then
  require'notifier'.setup()
end

if vim.fn['pac#loaded']('nvim-notify') then
  local notify = require("notify")
  notify.setup({
    -- render = "compact",
    background_colour = "NormalNC"
  })
  vim.notify = notify
end
