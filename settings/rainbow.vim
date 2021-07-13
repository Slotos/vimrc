if pac#loaded('nvim-ts-rainbow')
lua << LUA
  require'nvim-treesitter.configs'.setup {
    rainbow = {
      enable = true,
      extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    }
  }
LUA
endif
