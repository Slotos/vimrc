lua <<LUA
if vim.fn['pac#loaded']('indent-blankline.nvim') then
  require("indent_blankline").setup {
    enabled = false, -- it can slow down startup, but toggling afterwards is fast

    space_char_blankline = " ",
    use_treesitter = true,
    show_current_context = true,
    show_current_context_start = true,

    buftype_exclude = {"terminal"},
    filetype = {'vim', 'ruby', 'javascript', 'vue'},
    char_list = {'|', '¦', '┆', '┊'},
    context_patterns = {'class', 'function', 'method', 'lambda'},
  }
end
LUA
