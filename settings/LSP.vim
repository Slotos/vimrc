lua << LUA
vim.fn.sign_define("LspDiagnosticsSignError", {text = "", texthl = "Error"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "Warnings"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", texthl = "Operator"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", texthl = "String"})

if vim.fn['pac#loaded']('nvim-lspconfig') then
  local nvim_lsp = require('lspconfig')
  local attach_handlers = {}
  local capabilities = {}

  -- vim.lsp.set_log_level("debug")

  if vim.fn['pac#loaded']('lsp-status.nvim') then
    local lsp_status = require'lsp-status'
    lsp_status.register_progress()

    table.insert(attach_handlers, lsp_status.on_attach)

    capabilities = lsp_status.capabilities
  end

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

  -- Enable the following language servers
  local servers = { 'rust_analyzer', 'tsserver' }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities
    }
  end

  -- Ruby is special... as usual
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
