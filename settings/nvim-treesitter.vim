lua <<LUA
if vim.fn['pac#loaded']('nvim-treesitter') then
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
    },
    matchup = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
    },
    indent = {
      enable = true
    },
  }

  local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
  parser_config.embedded_template = {
    install_info = {
      url = "https://github.com/tree-sitter/tree-sitter-embedded-template", -- local path or git repo
      files = {"src/parser.c"},
      -- optional entries:
      requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
    },
    filetype = "eruby", -- if filetype does not match the parser name
  }

  vim.api.nvim_command('augroup RubyTreeSitterFold')
  vim.api.nvim_command('au!')
  vim.api.nvim_command('autocmd FileType ruby,eruby setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()')
  vim.api.nvim_command('augroup END')

  vim.api.nvim_command('augroup JsTreeSitterFold')
  vim.api.nvim_command('au!')
  vim.api.nvim_command('autocmd FileType javascript setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()')
  vim.api.nvim_command('augroup END')

  vim.api.nvim_set_keymap('n', '<leader>h', ":TSHighlightCapturesUnderCursor<CR>", {silent=true})
end
LUA
