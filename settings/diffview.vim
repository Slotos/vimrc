lua <<LUA

if vim.fn['pac#loaded']('diffview.nvim') then
  local cb = require'diffview.config'.diffview_callback

  require'diffview'.setup {
    enhanced_diff_hl = true,
  }
end

LUA
