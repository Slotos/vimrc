local utils = vim.g.local_lsp_utils and vim.g.local_lsp_utils()
if utils then utils.setup_filetype_lsp('go') end

vim.bo.expandtab = false
