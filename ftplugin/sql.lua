if vim.fn.executable("sqlformat") then
  vim.bo.formatprg = "sqlformat --reindent --keywords upper --identifiers lower -s --indent_after_first --comma_first true -"
end
