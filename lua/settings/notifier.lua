if vim.fn['pac#loaded']('notifier.nvim') then
  require'notifier'.setup()
end

if vim.fn['pac#loaded']('nvim-notify') then
  vim.schedule(function()
    local notify = require("notify")
    notify.setup({
      -- render = "compact",
      background_colour = "NormalNC"
    })
    vim.notify = notify

    if vim.fn['pac#loaded']('nvim-lsp-notify') then
      require('lsp-notify').setup({})
    end
  end)
end
