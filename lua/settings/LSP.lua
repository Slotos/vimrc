local H = {}

H.keymap_opts = function(bufnr)
  return { noremap = true, silent = true, buffer = bufnr }
end

local blinkLoaded, blinkMod = pcall(require, 'blink.cmp')
H.setupBlink = function()
  if blinkLoaded then
    blinkMod.setup({
      keymap = {
        preset = 'enter',
        ['<Tab>'] = {
          function(cmp)
            local _, col = unpack(vim.api.nvim_win_get_cursor(0))
            local char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
            if string.match(char, "%s") or char == "" then
              return
            end
            return cmp.show()
          end,
          'select_next', 'snippet_forward', 'fallback'
        },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      },
      completion = {
        -- 'prefix' will fuzzy match on the text before the cursor
        -- 'full' will fuzzy match on the text before _and_ after the cursor
        -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
        keyword = { range = 'full' },

        documentation = { auto_show = true, },
        ghost_text = { enabled = true, },
        list = {
          selection = { preselect = false, auto_insert = false, },
        }
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
    })

    H.setupBlink = function(_, _)
      return true
    end
  else
    H.setupBlink = function(_, _)
      return false
    end
  end

  return H.setupBlink()
end

H.setupCompletion = function(client, bufnr)
  vim.b[bufnr].completion = true
  local use_blink = H.setupBlink()
  if not use_blink and client:supports_method('textDocument/completion') then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end
end

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "Error" })
vim.fn.sign_define("DiagnosticSignWarning", { text = "", texthl = "Warnings" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "Operator" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "String" })

-- vim.lsp.set_log_level("debug")

local lightbulb_loaded, lightbulb = pcall(require, 'nvim-lightbulb')
if not lightbulb_loaded then lightbulb = nil end

vim.api.nvim_create_augroup('LspWatchers', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
  group = 'LspWatchers',
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, H.keymap_opts(bufnr))
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, H.keymap_opts(bufnr))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, H.keymap_opts(bufnr))
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, H.keymap_opts(bufnr))
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.add_workspace_folder, H.keymap_opts(bufnr))    -- mnemonic: LSP add
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.remove_workspace_folder, H.keymap_opts(bufnr)) -- LSP remove
    vim.keymap.set('n', '<leader>ll', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      H.keymap_opts(bufnr))                                                                      -- LSP list
    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, H.keymap_opts(bufnr))                -- Run codelens
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, H.keymap_opts(bufnr))

    -- Commented out static capability check.
    vim.keymap.set('n', '<localleader>f', function() vim.lsp.buf.format({ async = true }) end,
      vim.tbl_extend("force", H.keymap_opts(bufnr), { desc = "Format buffer with LSP" }))

    -- Enable inlay hints
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      vim.api.nvim_buf_create_user_command(
        bufnr,
        'IHToggle',
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr }) end,
        { desc = "Toggle buffer's inlay hints" }
      )
    end

    H.setupCompletion(client, args.buf)

    vim.api.nvim_create_augroup('CodeLensOrAction', { clear = false })
    vim.api.nvim_clear_autocmds({
      group = 'CodeLensOrAction',
      buffer = bufnr,
    })
    -- CodeAction
    if lightbulb then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' },
        {
          group = 'CodeLensOrAction',
          buffer = bufnr,
          callback = function() vim.schedule(lightbulb.update_lightbulb) end,
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
if pcall(require, "mason") then
  require("mason").setup()
end

local lsp_servers = {
  { "ruby_lsp", {
    init_options = {
      linters = { "rubocop" }
    }
  } },
  { "solargraph", {
    settings = {
      solargraph = {
        diagnostics = true,
        formatting = true,
        useBundler = false,
      },
    },
  } },
  { "gopls", {
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
  } },
  { "lua_ls", {
    on_init = function(client)
      local path = client.workspace_folders[1].name
      -- Skip if local luarc settings exist
      local fileConfig = {}
      if vim.uv.fs_stat(path .. '/.luarc.json') then
        local configFd = assert(vim.uv.fs_open(path .. '/.luarc.json', 'r', tonumber('444', 8)))
        local configStat = assert(vim.uv.fs_fstat(configFd))
        local configContents = assert(vim.uv.fs_read(configFd, configStat.size, 0))
        assert(vim.uv.fs_close(configFd))
        fileConfig = vim.json.decode(configContents)
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT'
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          -- library = {
          --   vim.env.VIMRUNTIME,
          -- }
          -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
          library = vim.api.nvim_get_runtime_file("", true)
        }
      }, fileConfig)
    end,
    settings = {
      Lua = {
        hint = {
          enable = true,
          setType = true,
        }
      }
    }
  } },
  { "clangd", {
    on_init = function()
      local ext_loaded, extensions = pcall(require, "clangd_extensions")
      if not ext_loaded then return end

      extensions.setup({
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
  } },
  { "pylsp", {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = { 'E501' },
            maxLineLength = 100
          },
        }
      }
    },
    on_attach = function(client)
      client.server_capabilities.renameProvider = false
    end
  } },
  { "basedpyright", {} },
  { "ruff", {
    init_options = {
      settings = {
        lineLength = 100
      }
    }
  } },
  { "yamlls", {
    settings = {
      yaml = {
        validate = true,
        hover = true,
        completion = true,
        format = {
          enable = true,
          proseWrap = 'always',
        },
        schemaStore = {
          enable = true,
        },
        customTags = {
          "!And scalar",
          "!And mapping",
          "!And sequence",
          "!If scalar",
          "!If mapping",
          "!If sequence",
          "!Not scalar",
          "!Not mapping",
          "!Not sequence",
          "!Equals scalar",
          "!Equals mapping",
          "!Equals sequence",
          "!Or scalar",
          "!Or mapping",
          "!Or sequence",
          "!FindInMap scalar",
          "!FindInMap mappping",
          "!FindInMap sequence",
          "!Base64 scalar",
          "!Base64 mapping",
          "!Base64 sequence",
          "!Cidr scalar",
          "!Cidr mapping",
          "!Cidr sequence",
          "!Ref scalar",
          "!Ref mapping",
          "!Ref sequence",
          "!Sub scalar",
          "!Sub mapping",
          "!Sub sequence",
          "!GetAtt scalar",
          "!GetAtt mapping",
          "!GetAtt sequence",
          "!GetAZs scalar",
          "!GetAZs mapping",
          "!GetAZs sequence",
          "!ImportValue scalar",
          "!ImportValue mapping",
          "!ImportValue sequence",
          "!Select scalar",
          "!Select mapping",
          "!Select sequence",
          "!Split scalar",
          "!Split mapping",
          "!Split sequence",
          "!Join scalar",
          "!Join mapping",
          "!Join sequence",
        },
      }
    }
  } },
  { "taplo" },
  { "ts_ls", {
    init_options = {
      preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
        importModuleSpecifierPreference = 'non-relative',
      },
    },
  } },
  { "lexical",                        { cmd = { "lexical" } } },
  { "dockerls" },
  { "docker_compose_language_service" },
  { "emmet_language_server" },
}

for _, lsp_server in ipairs(lsp_servers) do
  local server_name, init_options = unpack(lsp_server)
  init_options = init_options or {}
  vim.lsp.config(server_name, init_options)
  vim.lsp.enable(server_name)
end
