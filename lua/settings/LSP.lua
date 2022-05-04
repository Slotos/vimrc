vim.fn.sign_define("DiagnosticSignError", {text = "", texthl = "Error"})
vim.fn.sign_define("DiagnosticSignWarning", {text = "", texthl = "Warnings"})
vim.fn.sign_define("DiagnosticSignInformation", {text = "", texthl = "Operator"})
vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "String"})

if vim.fn['pac#loaded']('nvim-lspconfig') then
  local lspconfig = require('lspconfig')
  local attach_handlers = {}

  -- vim.lsp.set_log_level("debug")

  if vim.fn['pac#loaded']('aerial.nvim') then
    local aerial = require'aerial'

    table.insert(attach_handlers, aerial.on_attach)
  end

  local on_attach = function(...)
    local args = {...}

    for _, handler in pairs(attach_handlers) do
      handler(unpack(args))
    end
  end

  if vim.fn['pac#loaded']('nvim-lsp-installer') then
    local lsp_installer = require("nvim-lsp-installer")
    local opts = {
      on_attach = on_attach,
    }

    lsp_installer.on_server_ready(function(server)
      local server_opts = {}

      if server.name == "solargraph" then
        server_opts = {
          flags = { debounce_text_changes = 150, },
          settings = {
            solargraph = {
              diagnostics = true,
              formatting = true,
            }
          },
        }
      elseif server.name == "sumneko_lua" then
        local runtime_path = vim.split(package.path, ';')
        table.insert(runtime_path, "lua/?.lua")
        table.insert(runtime_path, "lua/?/init.lua")

        server_opts = {
          settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                enable = false,
              },
            },
          },
        }
      end

      local config = vim.tbl_deep_extend('force', server_opts, opts)

      lspconfig[server.name].setup(config)
      -- Direct cpy from lspconfig own code with certain edit
      -- When opening files, we want to attach to them even
      -- if this code executes after the files get loaded
      --
      -- lspconfig only does this in case of reload,
      -- expecting us to never load it in a callback,
      -- which is not what we do here.
      -- And it seems that sitting in a callback reliably
      -- places this code after the file loading event
      --
      -- A way to work around this would be to load installed
      -- servers, setup those immediately, keep the list
      -- and skip each one in the list exactly once in this callback.
      --
      -- I think I prefer this version.
      if config.autostart ~= false then
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          lspconfig[server.name].manager.try_add_wrapper(bufnr)
        end
      end
    end)

    lsp_installer.setup({})
  end
end