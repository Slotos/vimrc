if vim.fn['pac#loaded']('nvim-dap') then
  local dap = require('dap')

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<F5>', dap.continue)
  vim.keymap.set('n', '<F10>', dap.step_over)
  vim.keymap.set('n', '<F11>', dap.step_into)
  vim.keymap.set('n', '<F12>', dap.step_out)
  vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint)
  vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
  vim.keymap.set('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
  vim.keymap.set('n', '<Leader>dr', dap.repl.open)
  vim.keymap.set('n', '<Leader>dl', dap.run_last)

  if vim.fn['pac#loaded']('nvim-dap-ui') then
    local dapui = require('dapui')
    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    -- dap.listeners.before.event_terminated["dapui_config"] = function()
    --   dapui.close()
    -- end
    -- dap.listeners.before.event_exited["dapui_config"] = function()
    --   dapui.close()
    -- end

    vim.api.nvim_create_user_command('DapUIClose', dapui.close, {})
  end

  if vim.fn['pac#loaded']('nvim-dap-go') then
    require('dap-go').setup()
  end

  if vim.fn['pac#loaded']('nvim-dap-ruby') then
    require('dap-ruby').setup()
  end
end
