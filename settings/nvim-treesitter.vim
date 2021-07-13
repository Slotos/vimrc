lua <<LUA
if vim.fn['pac#loaded']('nvim-treesitter') then
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  },
  matchup = {
    enable = true,
  }
}
end
LUA
