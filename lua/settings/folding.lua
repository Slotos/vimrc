if vim.fn['pac#loaded']('pretty-fold.nvim') then
  require('pretty-fold').setup({
    fill_char = '┈',
  })
end
