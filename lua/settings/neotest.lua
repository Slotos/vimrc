if vim.fn['pac#loaded']('neotest') then
  local adapters = {}

  if vim.fn['pac#loaded']('neotest-rspec') then
    table.insert(adapters, require("neotest-rspec"))
  end

  local neotest = require("neotest")

  neotest.setup({
    adapters = adapters
  })

  vim.keymap.set(
    {"n", "x"},
    "]n",
    function() neotest.jump.next({ status = "failed" }) end,
    { desc = "Next test" }
  )
  vim.keymap.set(
    {"n", "x"},
    "[n",
    function() neotest.jump.prev({ status = "failed" }) end,
    { desc = "Previous test" }
  )
end
