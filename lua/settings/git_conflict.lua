if vim.fn['pac#loaded']('git-conflict.nvim') then
  local git_conflict = require('git-conflict')
  local setupGitconflict = function()
    git_conflict.setup({
      default_mappings = true,
      disable_diagnostics = true,
    })
  end

  setupGitconflict()

  vim.api.nvim_create_augroup('GitConflict', { clear = true })
  vim.api.nvim_create_autocmd({ 'ColorScheme' },
    {
      group = 'GitConflict',
      callback = setupGitconflict,
      desc = 'Rerun GitConflict setup to update highlights',
    }
  )
end
