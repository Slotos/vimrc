lua << LUA
vim.fn.sign_define("DiagnosticSignError", {text = "", texthl = "Error"})
vim.fn.sign_define("DiagnosticSignWarning", {text = "", texthl = "Warnings"})
vim.fn.sign_define("DiagnosticSignInformation", {text = "", texthl = "Operator"})
vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "String"})

if vim.fn['pac#loaded']('nvim-lspconfig') then
  local nvim_lsp = require('lspconfig')
  local attach_handlers = {}

  -- vim.lsp.set_log_level("debug")

  if vim.fn['pac#loaded']('aerial.nvim') then
    local aerial = require'aerial'

    table.insert(attach_handlers, aerial.on_attach)
  end

  local on_attach = function(...)
    local args = {...}

    for _key, handler in pairs(attach_handlers) do
      handler(unpack(args))
    end
  end

  if vim.fn['pac#loaded']('fidget.nvim') then
    require"fidget".setup{}
  end

  if vim.fn['pac#loaded']('nvim-lsp-installer') then
    local lsp_installer = require("nvim-lsp-installer")

    -- Register a handler that will be called for all installed servers.
    -- Alternatively, you may also register handlers on specific server instances instead (see example below).
    lsp_installer.on_server_ready(function(server)
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      -- (optional) Customize the options passed to the server
      if server.name == "solargraph" then

        opts.filetypes = { "ruby" }
        opts.flags = { debounce_text_changes = 150, }
        opts.settings = {
          solargraph = {
            diagnostics = true,
            formatting = true,
            }
          }
      end

      -- This setup() function is exactly the same as lspconfig's setup function.
      -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      server:setup(opts)
    end)
  end
end
LUA
