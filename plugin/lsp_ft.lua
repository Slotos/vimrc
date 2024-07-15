-- A naive filetype autocommand handler to initialize and attach corresponding LSP
--   Initially, I wanted to implement a cached nvim-lspconfig filetype search,
--   automatically setting up any LSP that had an executable executable present,
--   but after dealing with two LSPs at the same time once, I sobered up and went with
--   a minimal solution
local utils = {}

-- TODO: Replace "pac#loaded" with a cached pcall
local lsp_config = function(name, config)
  local lspconfig = {}
  if vim.fn["pac#loaded"]("nvim-lspconfig") then
    lspconfig = require("lspconfig")
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if vim.fn["pac#loaded"]("cmp-nvim-lsp") then
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      or capabilities
  end

  return lspconfig[name],
    vim.tbl_deep_extend("force", {
      capabilities = capabilities,
      flags = { debounce_text_changes = 150 },
    }, config or {})
end

local set_up_servers = {}

local ruby_handler = function()
  utils.run_lsp("ruby_lsp", {
    init_options = {
      linters = {"rubocop"}
    }
  })
  utils.run_lsp("solargraph", {
    settings = {
      solargraph = {
        diagnostics = true,
        formatting = true,
        useBundler = false,
      },
    },
  })
end

local go_handler = function()
  utils.run_lsp("gopls", {
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
end

local lua_handler = function()
  utils.run_lsp("lua_ls", {
    on_init = function(client)
      local path = client.workspace_folders[1].name
      -- Skip if local luarc settings exist
      if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
        return
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT'
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
          }
          -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
          -- library = vim.api.nvim_get_runtime_file("", true)
        }
      })
    end,
    settings = {
      Lua = {}
    }
  })
end

local c_handler = function()
  if vim.fn["pac#loaded"]("clangd_extensions.nvim") then
    require("clangd_extensions").setup({
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

  utils.run_lsp("clangd")
end

local python_handler = function()
  utils.run_lsp("pylsp", {})
end

local fthandlers = {
  ruby = ruby_handler,
  go = go_handler,
  gomod = go_handler,
  gotmpl = go_handler,
  gowork = go_handler,
  lua = lua_handler,
  c = c_handler,
  cpp = c_handler,
  cuda = c_handler,
  objc = c_handler,
  objcpp = c_handler,
  proto = c_handler,
  python = python_handler,
}

---@param ft string
utils.setup_filetype_lsp = function(ft)
  if fthandlers[ft] then
    (fthandlers[ft])()

    fthandlers[ft] = nil
  end
end

---@param lsp_name string
---@param opts? table
---@param bufnr? number
utils.run_lsp = function(lsp_name, opts, bufnr)
  vim.validate({
    lsp_name = { lsp_name, "string" },
    bufnr = { bufnr, "number", true },
    opts = { opts, "table", true },
  })
  if not bufnr or bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end

  vim.schedule(function()
    if set_up_servers[lsp_name] or not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    local langserver, options = lsp_config(lsp_name, opts or {})

    local cmd = langserver
    and langserver.document_config
    and langserver.document_config.default_config
    and langserver.document_config.default_config.cmd[1]

    if cmd and vim.fn.executable(cmd) == 1 then
      set_up_servers[lsp_name] = true
      langserver.setup(options)
      langserver.manager:try_add(bufnr)
    end
  end)
end

vim.api.nvim_create_autocmd({'FileType'}, {
  group = vim.api.nvim_create_augroup('LspFT', { clear = true }),
  callback = function(args)
    utils.setup_filetype_lsp(args.match)
  end
})
