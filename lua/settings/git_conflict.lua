if vim.fn['pac#loaded']('git-conflict.nvim') then
  require('git-conflict').setup({
    default_mappings = true,
    disable_diagnostics = true,
  })
end
