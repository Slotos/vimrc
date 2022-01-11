lua << LUA
if vim.fn['pac#loaded']('nvim-cmp') then
  -- Set completeopt to have a better completion experience
  vim.o.completeopt="menu,menuone,noselect"

  -- Setup nvim-cmp.
  local cmp = require'cmp'

  local options = {
    mapping = {
      ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<Down>'] = {
        i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        },
      ['<Up>'] = {
        i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        },
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
      }),
    },
    sources = {},
    experimental = {
      native_menu = true
    },
  }

  if vim.fn['pac#loaded']('vim-vsnip') then
    options.snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end }
  end

  if vim.fn['pac#loaded']('cmp-treesitter') then
    table.insert(options["sources"], { name = 'treesitter' })
  end

  if vim.fn['pac#loaded']('cmp-nvim-lsp') then
    table.insert(options["sources"], { name = 'nvim_lsp' })
  end

  if vim.fn['pac#loaded']('cmp-buffer') then
    table.insert(options["sources"], { name = 'buffer' })
  end

  if vim.fn['pac#loaded']('cmp-path') then
    table.insert(options["sources"], { name = 'path' })
  end

  if vim.fn['pac#loaded']('cmp-latex_symbols') then
    table.insert(options["sources"], { name = 'latex_symbols' })
  end

  if vim.fn['pac#loaded']('lspkind-nvim') then
    options["formatting"] = {
      format = require'lspkind'.cmp_format({with_text = false, maxwidth = 50})
    }
  end

  cmp.setup(options)

  -- Waiting for https://github.com/neovim/neovim/issues/11439 fix
  -- cmp.setup.cmdline('/', {
  --   sources = {
  --     { name = 'buffer' }
  --     }
  --   })

  -- cmp.setup.cmdline(':', {
  --   sources = cmp.config.sources({
  --     { name = 'path' }
  --   }, {
  --     { name = 'cmdline' }
  --   })
  -- })
end
LUA
