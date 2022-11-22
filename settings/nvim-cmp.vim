lua << LUA
if vim.fn['pac#loaded']('nvim-cmp') then
  -- Set completeopt to have a better completion experience
  vim.o.completeopt="menu,menuone,noselect"

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'sql,mysql,plsql',
    group = vim.api.nvim_create_augroup('CmpDadBod', { clear = true }),
    callback = function()
      require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
    end,
    desc = 'Set up vim-dadbod completion source for sql buffers',
  })

  -- Setup nvim-cmp.
  local cmp = require'cmp'

  local options = {
    mapping = {
      ['<Tab>'] = cmp.mapping({
        i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        -- c = function()
        --   if cmp.visible() then
        --     cmp.confirm({select = true})
        --     cmp.close()
        --   end
        --   cmp.complete()
        -- end,
        }),
      ['<S-Tab>'] = cmp.mapping({
        i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        -- c = function() end,
        }),
      ['<Down>'] = cmp.mapping({
        i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        }),
      ['<Up>'] = cmp.mapping({
        i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        }),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
      }),
    },
    sources = {},
    experimental = {
      ghost_text = true,
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

  if vim.fn['pac#loaded']('cmp-nvim-lsp-signature-help') then
    table.insert(options["sources"], { name = 'nvim_lsp_signature_help' })
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

  if vim.fn['pac#loaded']('cmp-emoji') then
    table.insert(options["sources"], { name = 'emoji' })
  end

  if vim.fn['pac#loaded']('lspkind-nvim') then
    options["formatting"] = {
      format = require'lspkind'.cmp_format({
        mode = 'symbol',
        maxwidth = 50,
        ellipsis_char = '…',
      })
    }
  end

  cmp.setup(options)

  -- Need to figure out controls that incorporate vim defaults
  -- cmp.setup.cmdline('/', {
  --   sources = {
  --     { name = 'buffer' }
  --   }
  -- })

  -- cmp.setup.cmdline(':', {
  --   sources = cmp.config.sources({
  --     { name = 'path' }
  --   }, {
  --     { name = 'cmdline' }
  --   })
  -- })
end
LUA
