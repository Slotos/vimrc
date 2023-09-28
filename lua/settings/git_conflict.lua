if vim.fn['pac#loaded']('git-conflict.nvim') then
  local git_conflict = require('git-conflict')
  local setupGitconflict = function()
    git_conflict.setup({
      default_mappings = false,
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
  vim.api.nvim_create_autocmd('User',
    {
      group = 'GitConflict',
      pattern = 'GitConflictDetected',
      callback = function(args)
        local bufnr = args.buf
        local filename = vim.fn.expand('<afile>')
        vim.schedule(function()
          vim.notify('Conflict detected in ' .. filename, vim.log.levels.INFO,
            { title = 'GitConflict', icon = ' ' })
        end)
        vim.keymap.set('n', '<localleader>co', '<Plug>(git-conflict-ours)',
          { buffer = bufnr, desc = 'Git conflict: choose ours' })
        vim.keymap.set('n', '<localleader>ct', '<Plug>(git-conflict-theirs)',
          { buffer = bufnr, desc = 'Git conflict: choose theirs' })
        vim.keymap.set('n', '<localleader>cb', '<Plug>(git-conflict-both)',
          { buffer = bufnr, desc = 'Git conflict: choose both' })
        vim.keymap.set('n', '<localleader>c0', '<Plug>(git-conflict-none)',
          { buffer = bufnr, desc = 'Git conflict: choose none' })
      end,
      desc = 'Setup buffer local git conflict keymaps when conflicts are detected',
    }
  )
  vim.api.nvim_create_autocmd('User',
    {
      group = 'GitConflict',
      pattern = 'GitConflictResolved',
      callback = function(args)
        local bufnr = args.buf
        local filename = vim.fn.expand('<afile>')
        vim.schedule(function()
          vim.notify('All conflicts resolved in ' .. filename, vim.log.levels.INFO,
            { title = 'GitConflict', icon = ' ' })
        end)
        for _, mapping in pairs(vim.api.nvim_buf_get_keymap(bufnr, "n")) do
          if mapping.rhs and string.find(mapping.rhs, "<Plug>(git-conflict") == 1 then
            vim.keymap.del("n", mapping.lhs, { buffer = bufnr })
          end
        end
        -- vim.keymap.del('n', '<localleader>co', { silent = true, buffer = bufnr })
        -- vim.keymap.del('n', '<localleader>ct', { silent = true, buffer = bufnr })
        -- vim.keymap.del('n', '<localleader>cb', { silent = true, buffer = bufnr })
        -- vim.keymap.del('n', '<localleader>c0', { silent = true, buffer = bufnr })
      end,
      desc = 'Remove buffer local git conflict keymaps when conflicts are resolved',
    }
  )
end
