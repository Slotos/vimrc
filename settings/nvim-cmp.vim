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
      ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
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
end
LUA