if vim.fn["pac#loaded"]("indent-blankline.nvim") then
  require("ibl").setup {
    enabled = false, -- it can slow down startup, but toggling afterwards is fast
    indent = {
      char = {"|", "¦", "┆", "┊"},
    },
  }

  vim.keymap.set("n", "<localleader>ii", ":IBLToggle<CR>", { silent = true })
  vim.keymap.set("n", "<localleader>is", ":IBLToggleScope<CR>", { silent = true })
end
