if vim.fn['pac#loaded']('translate.nvim') then
  vim.g.deepl_api_auth_key = vim.env.DEEPL_KEY

  vim.keymap.set(
    {"n", "x"},
    "<leader>t",
    function()
      local opts = {
        "EN",
        "-command=deepl_free",
      }

      if vim.api.nvim_buf_get_option(0, 'modifiable') then table.insert(opts, "--output=insert") end

      vim.cmd.Translate(unpack(opts))
    end,
    { desc = "Translate to English" }
  )
end
