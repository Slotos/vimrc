if vim.fn['pac#loaded']('neotest') then
  local adapters = {}

  if vim.fn['pac#loaded']('neotest-rspec') then
    table.insert(adapters, require("neotest-rspec"))
  end

  local neotest = require("neotest")

  neotest.setup({
    adapters = adapters
  })

  vim.keymap.set( {"n", "x"}, "]n", function() neotest.jump.next({ status = "failed" }) end, { desc = "Next test" } )
  vim.keymap.set( {"n", "x"}, "[n", function() neotest.jump.prev({ status = "failed" }) end, { desc = "Previous test" } )

  vim.keymap.set( {"n", "x"}, "<localleader>tr", function() neotest.run.run() end, { desc = "Run the nearest test" } )
  vim.keymap.set( {"n", "x"}, "<localleader>ta", function() neotest.run.attach() end, { desc = "Attach to the nearest test" } )
  vim.keymap.set( {"n", "x"}, "<localleader>ts", function() neotest.summary.toggle() end, { desc = "Toggle neotest summary pane" } )
  vim.keymap.set( {"n", "x"}, "<localleader>T", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run current file" } )
end
