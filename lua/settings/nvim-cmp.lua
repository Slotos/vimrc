if vim.fn['pac#loaded']('nvim-cmp') then
  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end

  -- Set completeopt to have a better completion experience
  vim.o.completeopt = "menu,menuone,noselect"

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'sql,mysql,plsql',
    group = vim.api.nvim_create_augroup('CmpDadBod', { clear = true }),
    callback = function()
      require('cmp').setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
    end,
    desc = 'Set up vim-dadbod completion source for sql buffers',
  })

  -- Setup nvim-cmp.
  local cmp = require 'cmp'

  local options = {
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif vim.fn["vsnip#available"](1) == 1 then
          feedkey("<Plug>(vsnip-expand-or-jump)", "")
        elseif has_words_before() then
          cmp.complete()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end),

      ["<S-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          feedkey("<Plug>(vsnip-jump-prev)", "")
        end
      end),
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
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
      }),
    },
    sources = {},
    experimental = {
      ghost_text = true,
    },
    preselect = cmp.PreselectMode.None,
    completion = {
      autocomplete = false,
    }
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

  if vim.fn['pac#loaded']('cmp-nerdfont') then
    table.insert(options["sources"], { name = 'nerdfont' })
  end

  if vim.fn['pac#loaded']('cmp-emmet-vim') then
    table.insert(options["sources"], { name = 'emmet_vim' })
  end

  if vim.fn['pac#loaded']('cmp-omni') then
    table.insert(options["sources"], {
      name = 'omni',
      option = {
        disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' }
      }
    })
  end

  if vim.fn['pac#loaded']('lspkind-nvim') then
    options["formatting"] = {
      format = require 'lspkind'.cmp_format({
        mode = 'symbol',
        maxwidth = 50,
        ellipsis_char = '…',
      })
    }
  end

  cmp.setup(options)

  -- `/` cmdline setup.
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    },
    completion = {
      autocomplete = false,
    }
  })

  -- `:` cmdline setup.
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      {
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }
    ),
    completion = {
      autocomplete = false,
    }
  })
end
