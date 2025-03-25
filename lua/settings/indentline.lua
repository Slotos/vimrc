vim.schedule(function()
  if vim.fn.exists(':IBLToggle') > 0 then
    vim.keymap.set("n", "<localleader>ii", ":IBLToggle<CR>", { silent = true })
    vim.keymap.set("n", "<localleader>is", ":IBLToggleScope<CR>", { silent = true })

    require("ibl").setup {
      enabled = false, -- it can slow down startup, but toggling afterwards is fast
      indent = {
        char = {"│", "╎", "┆", "┊"},
      },
    }
  end
end)
