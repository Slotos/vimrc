local M = {}

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

local fthandlers = {
  ruby = function()
    M.run_lsp("ruby_ls")
    M.run_lsp("solargraph", {
      settings = {
        solargraph = {
          diagnostics = true,
          formatting = true,
          useBundler = false,
        },
      },
    })
  end,
  go = function()
    M.run_lsp("gopls", {
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
  end,
  lua = function()
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    M.run_lsp("lua_ls", {
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            checkThirdParty = false,
            -- Make the server aware of Neovim runtime files
            library = {
              vim.api.nvim_get_runtime_file("lua", true),
            }
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end,
  c = function()
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

    M.run_lsp("clangd")
  end,
}

---@param ft string
M.setup_filetype_lsp = function(ft)
  if fthandlers[ft] then
    (fthandlers[ft])()

    fthandlers[ft] = nil
  end
end

---@param lsp_name string
---@param opts? table
---@param bufnr? number
M.run_lsp = function(lsp_name, opts, bufnr)
  vim.validate({
    lsp_name = { lsp_name, "string" },
    bufnr = { bufnr, "number", true },
    opts = { opts, "table", true },
  })
  if not bufnr or bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  if not set_up_servers[lsp_name] then
    vim.schedule(function()
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
end

return M
