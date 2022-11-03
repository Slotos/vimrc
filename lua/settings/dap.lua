if vim.fn['pac#loaded']('nvim-dap') then
  local dap = require('dap')

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

  local function get_arguments()
    local co = coroutine.running()
    if co then
      return coroutine.create(function()
        local args = vim.split(vim.fn.input('Args: ') or "", " ")
        coroutine.resume(co, args)
      end)
    else
      local args = vim.split(vim.fn.input('Args: ') or "", " ")
      return args
    end
  end

  dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
      -- CHANGE THIS to your path!
      command = 'codelldb',
      args = {"--port", "${port}"},
    }
  }

  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = 'OpenDebugAD7',
  }

  dap.configurations.cpp = {
    {
      name = "Launch file (CPP tools)",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopAtEntry = true,
    },
    {
      name = "Launch file with arguments (CPP tools)",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopAtEntry = true,
      args = get_arguments,
    },
    {
      name = "Launch file (LLDB)",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = true,
    },
    {
      name = "Launch file with arguments (LLDB)",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = true,
      args = get_arguments,
    },
  }
end
