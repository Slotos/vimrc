if vim.fn['pac#loaded']('refactoring.nvim') then
  vim.keymap.set(
    {"n", "x"},
    "<leader>rr",
    function() require('refactoring').select_refactor() end
  )
end
