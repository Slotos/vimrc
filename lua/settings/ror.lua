if vim.fn['pac#loaded']('ror.nvim') then
  require("ror").setup({
    test = {
      notification = {
        timeout = 2000 -- milliseconds
      }
    }
  })
end
