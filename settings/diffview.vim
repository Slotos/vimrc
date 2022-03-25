lua <<LUA

if vim.fn['pac#loaded']('diffview.nvim') then
  require'diffview'.setup {
    enhanced_diff_hl = true,
  }
end

LUA
