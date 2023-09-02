if vim.fn['pac#loaded']('nvim-dap') then
  if vim.fn['pac#loaded']('nvim-dap-virtual-text') then
    require('nvim-dap-virtual-text').setup({})
  end

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

  local function get_path()
    local co = coroutine.running()
    if co then
      return coroutine.create(function()
        local args = vim.fn.input('Path: ') or ""
        coroutine.resume(co, args)
      end)
    else
      local args = vim.fn.input('Path: ') or ""
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

  dap.configurations.rust = {
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
  dap.configurations.c = dap.configurations.cpp

  dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
  end

  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = "Attach to running Neovim instance",
    }
  }

  dap.adapters.bashdb = {
    type = 'executable',
    command = 'bash-debug-adapter',
    name = 'bashdb',
  }

  dap.configurations.sh = {
    {
      type = 'bashdb',
      request = 'launch',
      name = "Launch file",
      showDebugOutput = true,
      pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
      pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
      trace = true,
      file = "${file}",
      program = "${file}",
      cwd = '${workspaceFolder}',
      pathCat = "cat",
      pathBash = "/usr/local/bin/bash",
      pathMkfifo = "mkfifo",
      pathPkill = "pkill",
      args = {},
      env = {},
      terminalKind = "integrated",
    }
  }

  -- Taken from nvim-dap-ruby and updated for piped communication (I don't wanna fight for ports)
  dap.adapters.ruby = function(callback, config)
    if type(config.script) == "function" then
      script = config.script()
    else
      script = vim.split(config.script or "", " ")
    end

    if type(script) ~= "table" then
      script = { script }
    end

    if config.pipe then
      if type(config.pipe) == "function" then
        pipe = config.pipe()
      else
        pipe = config.pipe
      end
    else
      pipe = "${pipe}"
    end

    if config.bundle then
      args = {"-n", "--open", "--sock-path=" .. pipe, "-c", "--", "bundle", "exec", config.command, table.unpack(script)}
    else
      args = {"--open", "--sock-path=" .. pipe, "-c", "--", config.command, table.unpack(script)}
    end

    if config.command then
      executable = {
        command = "rdbg",
        args = args,
        detached = config.detached,
      }
    else
      executable = nil
    end

    if config.host then
      -- docker connection here
    else
      callback {
        type = "pipe",
        pipe = pipe,
        executable = executable,
      }
    end
  end

  dap.configurations.ruby = {
    {
      type = 'ruby';
      name = 'RSpec current_file:current_line';
      bundle = true;
      request = 'attach';
      command = "rspec";
      script = function() return vim.api.nvim_buf_get_name(0) .. ":" .. vim.fn.line(".") end;
      options = {
        source_filetype = 'ruby';
      };
    },
    {
      type = 'ruby';
      name = 'RSpec curent_file';
      bundle = true;
      request = 'attach';
      command = "rspec";
      script = "${file}";
      options = {
        source_filetype = 'ruby';
      };
    },
    {
      type = 'ruby';
      name = 'RSpec ./spec';
      bundle = true;
      request = 'attach';
      command = "rspec";
      script = "./spec";
      options = {
        source_filetype = 'ruby';
      };
    },
    -- nvim-dap gives up if remote server accepts connection and stays silent. See `on_no_chunk`
    -- Even after a dirty fix, breakpoints don't work
    -- And rails servers love hanging up and staying after parent left
    -- So stick with "attach via socker" options for now
    -- {
    --   type = 'ruby';
    --   name = 'Rails server (start and attach) // Broken, needs fixing in nvim-dap';
    --   bundle = true;
    --   request = 'attach';
    --   command = "rails";
    --   script = "s -u thin";
    --   options = {
    --     source_filetype = 'ruby';
    --     initialize_timeout_sec = 3;
    --   };
    -- },
    {
      type = 'ruby';
      name = 'Rails server (attach via socket)';
      request = 'attach';
      pipe = get_path;
      options = {
        source_filetype = 'ruby';
      };
    },
    {
      type = 'ruby';
      name = 'Debug current file';
      request = 'attach';
      command = "ruby";
      script = "${file}";
      options = {
        source_filetype = 'ruby';
      };
    },
  }
end
