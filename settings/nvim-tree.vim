lua <<LUA

if vim.fn['pac#loaded']('nvim-tree.lua') then
  require'nvim-tree'.setup()
end
LUA

let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_git_hl = 1
let g:nvim_tree_group_empty = 1
