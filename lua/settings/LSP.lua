vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "Error" })
vim.fn.sign_define("DiagnosticSignWarning", { text = "", texthl = "Warnings" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "Operator" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "String" })

if vim.fn['pac#loaded']('telescope-lsp-handlers.nvim') then
  require 'telescope-lsp-handlers'.setup({
    declaration = {
      disabled = false,
      picker = {
        prompt_title = 'LSP Declarations',
        entry = {
          trim_text = true,
          fname_width = 50,
        },
      },
      no_results_message = 'Declaration not found',
    },
    definition = {
      disabled = false,
      picker = {
        prompt_title = 'LSP Definitions',
        entry = {
          trim_text = true,
          fname_width = 50,
        },
      },
      no_results_message = 'Definition not found',
    },
    implementation = {
      disabled = false,
      picker = {
        prompt_title = 'LSP Implementations',
        entry = {
          trim_text = true,
          fname_width = 50,
        },
      },
      no_results_message = 'Implementation not found',
    },
    type_definition = {
      disabled = false,
      picker = {
        prompt_title = 'LSP Type Definitions',
        entry = {
          trim_text = true,
          fname_width = 50,
        },
      },
      no_results_message = 'Type definition not found',
    },
    reference = {
      disabled = false,
      picker = {
        prompt_title = 'LSP References',
        entry = {
          trim_text = true,
          fname_width = 50,
        },
      },
      no_results_message = 'No references found'
    },
    document_symbol = {
      disabled = false,
      picker = {
        prompt_title = 'LSP Document Symbols',
        entry = {
          trim_text = true,
          fname_width = 50,
        },
      },
      no_results_message = 'No symbols found',
    },
    workspace_symbol = {
      disabled = false,
      picker = {
        prompt_title = 'LSP Workspace Symbols',
        entry = {
          trim_text = true,
          fname_width = 50,
        },
      },
      no_results_message = 'No symbols found',
    },
    incoming_calls = {
      disabled = false,
      picker = {
        prompt_title = 'LSP Incoming Calls',
        entry = {
          trim_text = true,
          fname_width = 50,
        },
      },
      no_results_message = 'No calls found',
    },
    outgoing_calls = {
      disabled = false,
      picker = {
        prompt_title = 'LSP Outgoing Calls',
        entry = {
          trim_text = true,
          fname_width = 50,
        },
      },
      no_results_message = 'No calls found',
    },
  })
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
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if vim.fn['pac#loaded']('cmp-nvim-lsp') then
    capabilities = vim.tbl_deep_extend("force", capabilities, require('cmp_nvim_lsp').default_capabilities())
  end
  local open_code_action_menu = vim.fn['pac#loaded']('nvim-code-action-menu') and require('code_action_menu').open_code_action_menu or vim.lsp.buf.code_action
  local nvim_lightbulb_installed = vim.fn['pac#loaded']('nvim-lightbulb')

  vim.api.nvim_create_augroup('LspWatchers', { clear = true })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = 'LspWatchers',
    callback = function(args)
      if not (args.data and args.data.client_id) then
        return
      end

      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>la', vim.lsp.buf.add_workspace_folder, opts) -- mnemonic: LSP add
      vim.keymap.set('n', '<leader>lr', vim.lsp.buf.remove_workspace_folder, opts) -- LSP remove
      vim.keymap.set('n', '<leader>ll', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts) -- LSP list
      vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts) -- Run codelens
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

      vim.keymap.set('n', '<leader>ca', open_code_action_menu, opts)
      vim.keymap.set('v', '<leader>ca', open_code_action_menu, opts)

      -- Commented out static capability check.
      vim.keymap.set('n', '<localleader>f', function() vim.lsp.buf.format({ async = true }) end, opts)

      -- Enable inlay hints
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint(bufnr, true)
      end

      vim.api.nvim_create_augroup('CodeLensOrAction', { clear = true })
      -- CodeAction
      if nvim_lightbulb_installed then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' },
          {
            group = 'CodeLensOrAction',
            buffer = bufnr,
            callback = function() vim.schedule(require('nvim-lightbulb').update_lightbulb) end,
            desc = 'Refresh LSP code action lightbulb',
          }
        )
      end
      -- CodeLens
      if client.server_capabilities.codeLensProvider ~= nil then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'InsertLeave' },
          {
            group = 'CodeLensOrAction',
            buffer = bufnr,
            callback = function() vim.schedule(vim.lsp.codelens.refresh) end,
            desc = 'Refresh LSP code lens information',
          }
        )
        vim.lsp.codelens.refresh() -- run it on attach without waiting for events
      end
    end,
    desc = 'Set up buffer local mappings, lens etc on LSP attach',
  })

  local basic_lsp_config = {
    capabilities = capabilities,
    flags = { debounce_text_changes = 150, },
  }

  if vim.fn['pac#loaded']('mason.nvim') then
    require("mason").setup()

    if vim.fn['pac#loaded']('mason-lspconfig.nvim') then
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup()

      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup(basic_lsp_config)
        end,
        ["rust_analyzer"] = function()
          if vim.fn['pac#loaded']('rust-tools.nvim') then
            local config = {
              dap = {
                adapter = {
                  type = "server",
                  port = "${port}",
                  host = "127.0.0.1",
                  executable = {
                    command = 'codelldb',
                    args = { "--port", "${port}" },
                  },
                },
              },
            }

            require("rust-tools").setup(config)
          else
            lspconfig.rust_analyzer.setup(basic_lsp_config)
          end
        end,
        ["clangd"] = function()
          if vim.fn['pac#loaded']('clangd_extensions.nvim') then
            require('clangd_extensions').setup({
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
            })
          end

          lspconfig.clangd.setup(basic_lsp_config)
        end,
        ["lua_ls"] = function()
          local runtime_path = vim.split(package.path, ';')
          table.insert(runtime_path, "lua/?.lua")
          table.insert(runtime_path, "lua/?/init.lua")

          lspconfig.lua_ls.setup(
            vim.tbl_extend("force", basic_lsp_config, {
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
            })
          )
        end,
        ["solargraph"] = function()
          lspconfig.solargraph.setup(
            vim.tbl_extend("force", basic_lsp_config, {
              settings = {
                solargraph = {
                  diagnostics = true,
                  formatting = true,
                  useBundler = false,
                }
              },
            })
          )
        end,
        ["gopls"] = function()
          lspconfig.gopls.setup(
            vim.tbl_extend("force", basic_lsp_config, {
              settings = {
                gopls = {
                  hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                  },
                  semanticTokens = true,
                },
              },
            })
          )
        end,
      })
    end
  end

  lspconfig.ruby_ls.setup(basic_lsp_config)
end

-- LSP is not the only thing setting diagnostics, just the primary one
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
