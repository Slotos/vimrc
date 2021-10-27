lua << LUA
vim.fn.sign_define("LspDiagnosticsSignError", {text = "", texthl = "Error"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "Warnings"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", texthl = "Operator"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "String"})

if vim.fn['pac#loaded']('nvim-lspconfig') then
  local nvim_lsp = require('lspconfig')
  local attach_handlers = {}
  local capabilities = {}

  -- Y-combinator recursion over functions array
  local compose = function(...)
    local fnchain = {...}

    local function recurse(i, ...)
      if i == #fnchain then
        return fnchain[i](...)
      end

      return recurse(i + 1, fnchain[i](...))
    end

    return function(...)
      return recurse(1, ...)
    end
  end

  -- vim.lsp.set_log_level("debug")

  if vim.fn['pac#loaded']('lsp-status.nvim') then
    local lsp_status = require'lsp-status'
    lsp_status.register_progress()

    table.insert(attach_handlers, lsp_status.on_attach)

    capabilities = lsp_status.capabilities
  end

  local on_attach = compose(unpack(attach_handlers))

  -- Enable the following language servers
  local servers = { 'rust_analyzer', 'tsserver' }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities
    }
  end

  nvim_lsp.solargraph.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "ruby" },
    flags = { debounce_text_changes = 150, },
    settings = {
      solargraph = {
        diagnostics = true,
        formatting = true,
      }
    }
  }
end
LUA
