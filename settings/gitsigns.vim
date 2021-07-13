lua << LUA
if vim.fn['pac#loaded']('gitsigns.nvim') then
  require('gitsigns').setup()
end
LUA
