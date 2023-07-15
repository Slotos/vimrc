" Note: NVIM is always nocompatible

" ensure vim config path is first in packpath
" needed for minpac
if &packpath !~# stdpath('config')
  set packpath^=stdpath('config')
endif

" Set augroup
augroup MyAutoCmd
  autocmd!
augroup END

" Disable vim distribution plugins
let g:loaded_gzip = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:netrw_nogx = 1 " disable netrw's gx mapping.
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

" Disable ruby mappings, they break tagfunc
let g:no_ruby_maps = 1

" Global Mappings "{{{
" Use spacebar as leader and ; as secondary-leader
" Required before loading plugins!
let g:mapleader="\<Space>"
let g:maplocalleader=';'

" Initialize minpac
packadd minpac
call minpac#init({ 'jobs': -1, 'progress_open': 'tab', 'status_auto': v:true })
call minpac#add('k-takata/minpac', {'type': 'opt'})

" general and early settings
execute 'source' fnameescape(stdpath('config') . '/settings/general.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/style.vim')

" plugins
execute 'source' fnameescape(stdpath('config') . '/pac.vim')

" plugin configurations
execute 'source' fnameescape(stdpath('config') . '/settings/gitsigns.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/neoterm.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/hexokinase.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/vim-ruby.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/indentline.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/aerial.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/diffview.vim')

" Mappings
execute 'source' fnameescape(stdpath('config') . '/settings/allkey.vim')

" Generic configs
execute 'source' fnameescape(stdpath('config') . '/settings/cursorline.vim')

" Neovide
execute 'source' fnameescape(stdpath('config') . '/settings/neovide.vim')

" Custom plugins
execute 'source' fnameescape(stdpath('config') . '/plugins/hlsearch.vim')

lua <<LUA
  local this_file_path = vim.fn.fnamemodify(
    vim.fn.resolve(
      vim.fn.expand('<sfile>:p')
    ),
    ':h'
  )

  -- wrap execution into anonymous function
  -- in order to avoid polluting global namespace
  --- semicolon ensures this is not interpreted as
  --- a call on a return value of the above code
  ;(function()
    dofile(this_file_path .. '/lua/settings/notifier.lua')
    dofile(this_file_path .. '/lua/settings/tree-explorer.lua')
    -- LSP configuration and completion
    dofile(this_file_path .. '/lua/settings/LSP.lua')
    dofile(this_file_path .. '/lua/settings/telescope.lua')
    dofile(this_file_path .. '/lua/settings/git_conflict.lua')
    dofile(this_file_path .. '/lua/settings/lualine.lua')
    dofile(this_file_path .. '/lua/settings/dap.lua')
    dofile(this_file_path .. '/lua/settings/colorschemes.lua')
    dofile(this_file_path .. '/lua/settings/treesitter.lua')
    dofile(this_file_path .. '/lua/settings/silicon.lua')
    dofile(this_file_path .. '/lua/settings/folding.lua')
    dofile(this_file_path .. '/lua/settings/neoai.lua')
    dofile(this_file_path .. '/lua/settings/nvim-cmp.lua')
    dofile(this_file_path .. '/lua/settings/refactoring.lua')
  end)()
LUA

let b:local_override_file = fnameescape($HOME . '/.vimrc_local')
if filereadable(b:local_override_file)
  execute 'source' b:local_override_file
endif

set secure
