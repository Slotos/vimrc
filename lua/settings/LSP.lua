vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "Error" })
vim.fn.sign_define("DiagnosticSignWarning", { text = "", texthl = "Warnings" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "Operator" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "String" })

if vim.fn['pac#loaded']('telescope-lsp-handlers.nvim') then
  require'telescope-lsp-handlers'.setup()
end

if vim.fn['pac#loaded']('lsp_lines.nvim') then
  require("lsp_lines").setup()
  vim.diagnostic.config({
    virtual_text = false,
  })

  vim.keymap.set(
    "",
    "<Leader>ld",
    function()
      vim.diagnostic.config({
        virtual_text = vim.diagnostic.config().virtual_lines,
        virtual_lines = not vim.diagnostic.config().virtual_lines,
      })
    end,
    { desc = "Toggle lsp_lines" }
  )
end

if vim.fn['pac#loaded']('nvim-lspconfig') then
  -- vim.lsp.set_log_level("debug")

  local lspconfig = require('lspconfig')

  if vim.fn['pac#loaded']('nvim-lightbulb') then
    require('nvim-lightbulb').setup({autocmd = {enabled = true}})
  end

  local attach_handlers = {
    function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>la', vim.lsp.buf.add_workspace_folder, opts) -- mnemonic: LSP add
      vim.keymap.set('n', '<leader>lr', vim.lsp.buf.remove_workspace_folder, opts) -- LSP remove
      vim.keymap.set('n', '<leader>ll', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts) -- LSP list
      vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts) -- Run codelens
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

      if client.server_capabilities.documentFormattingProvider == true then
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
        vim.keymap.set('n', '<localleader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
      end

      if client.server_capabilities.definitionProvider == true then
        vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
      end

      -- CodeLens
      vim.api.nvim_create_augroup('CodeLens', { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'InsertLeave' },
        {
          group = 'CodeLens',
          buffer = bufnr,
          callback = vim.lsp.codelens.refresh,
          desc = 'Refresh LSP code lens information',
        }
      )
      vim.lsp.codelens.refresh() -- run it on attach without waiting for events
    end
  }

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

  if vim.fn['pac#loaded']('mason.nvim') then
    require("mason").setup()

    if vim.fn['pac#loaded']('mason-lspconfig.nvim') then
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup()

      local opts = {
        on_attach = on_attach,
      }

      mason_lspconfig.setup_handlers({
        function(server_name)
          local server_opts = {}

          if server_name == "solargraph" then
            server_opts = {
              flags = { debounce_text_changes = 150, },
              settings = {
                solargraph = {
                  diagnostics = true,
                  formatting = true,
                }
              },
            }
          elseif server_name == "sumneko_lua" then
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

          lspconfig[server_name].setup(config)

          -- Direct copy from lspconfig own code with certain edit
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
              lspconfig[server_name].manager.try_add_wrapper(bufnr)
            end
          end
        end
      })
    end
  end
end
