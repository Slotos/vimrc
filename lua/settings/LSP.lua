vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "Error" })
vim.fn.sign_define("DiagnosticSignWarning", { text = "", texthl = "Warnings" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "Operator" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "String" })

if vim.fn['pac#loaded']('telescope-lsp-handlers.nvim') then
  require 'telescope-lsp-handlers'.setup()
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
    require('nvim-lightbulb').setup({ autocmd = { enabled = true } })
  end

  vim.api.nvim_create_augroup('LspWatchers', { clear = true })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = 'LspWatchers',
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

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

      if vim.fn['pac#loaded']('nvim-code-action-menu') then
        vim.keymap.set('n', '<leader>ca', require('code_action_menu').open_code_action_menu, opts)
      else
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      end

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
      if client.server_capabilities.codeLensProvider ~= nil then
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
    end,
    desc = 'Set up buffer local mappings, lens etc on LSP attach',
  })

  if vim.fn['pac#loaded']('mason.nvim') then
    require("mason").setup()

    if vim.fn['pac#loaded']('mason-lspconfig.nvim') then
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup()

      mason_lspconfig.setup_handlers({
        function(server_name)
          local server_config = {}

          if server_name == "solargraph" then
            server_config = {
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

            server_config = {
              settings = {
                Lua = {
                  runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    -- path = runtime_path,
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
          elseif server_name == "clangd" then
            if vim.fn['pac#loaded']('clangd_extensions.nvim') then
              server_config = require('clangd_extensions').prepare({
                extensions = {
                  ast = {
                    role_icons = {
                      type = "",
                      declaration = "",
                      expression = "",
                      specifier = "",
                      statement = "",
                      ["template argument"] = "",
                    },

                    kind_icons = {
                      Compound = "",
                      Recovery = "",
                      TranslationUnit = "",
                      PackExpansion = "",
                      TemplateTypeParm = "",
                      TemplateTemplateParm = "",
                      TemplateParamObject = "",
                    },
                    highlights = {
                      detail = "Comment",
                    },
                  },
                  memory_usage = {
                    border = "none",
                  },
                  symbol_info = {
                    border = "none",
                  },
                },
              })
            end
          end

          -- Load default lspconfig config
          local default_config = {}
          local success, defaults = pcall(require, 'lspconfig.server_configurations.' .. server_name)
          if success then
            default_config = defaults.default_config
          end

          local config = vim.tbl_deep_extend('force', default_config, server_config)

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
