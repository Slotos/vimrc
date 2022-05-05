vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "Error" })
vim.fn.sign_define("DiagnosticSignWarning", { text = "", texthl = "Warnings" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "Operator" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "String" })

if vim.fn['pac#loaded']('nvim-lspconfig') then
  local lspconfig = require('lspconfig')
  local attach_handlers = {
    function(client, bufnr)
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>la', vim.lsp.buf.add_workspace_folder, opts) -- mnemonic: LSP add
      vim.keymap.set('n', '<leader>lr', vim.lsp.buf.remove_workspace_folder, opts) -- LSP remove
      vim.keymap.set('n', '<leader>ll', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts) -- LSP list
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

      if client.resolved_capabilities.document_formatting == true then
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
        vim.keymap.set('n', '<localleader>f', vim.lsp.buf.formatting, opts)
      end

      if client.resolved_capabilities.goto_definition == true then
        vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
      end
    end
  }

  -- vim.lsp.set_log_level("debug")

  if vim.fn['pac#loaded']('aerial.nvim') then
    local aerial = require 'aerial'

    table.insert(attach_handlers, aerial.on_attach)
  end

  local on_attach = function(...)
    local args = { ... }

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
                globals = { 'vim' },
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
