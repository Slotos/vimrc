local utils = vim.g.local_lsp_utils and vim.g.local_lsp_utils()
if utils then utils.setup_filetype_lsp('ruby') end

-- Bundled Ruby ftplugin introduces 0.5+s delay on initial load
-- What's weird, --startuptime doesn't register any calls - there's simply an delay between require('vim.filetupe') and the next line (which is not even ruby ftplugin)
-- I managed to track it down to `has('ruby')` call, which seems to do something similar to `ruby -e 'require "neovim"'`
-- I don't really care for vim-ruby, tree-sitter so far is sufficient
vim.b.did_ftplugin = 1

vim.bo.comments='b:#'
vim.bo.commentstring='# %s'
