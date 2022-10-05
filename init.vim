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
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})

" general and early settings
execute 'source' fnameescape(stdpath('config') . '/settings/general.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/style.vim')

" plugins
execute 'source' fnameescape(stdpath('config') . '/pac.vim')

" LSP configuration and completion
execute 'source' fnameescape(stdpath('config') . '/settings/nvim-cmp.vim')

" plugin configurations
execute 'source' fnameescape(stdpath('config') . '/settings/gitsigns.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/nvim-treesitter.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/neoterm.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/vim-choosewin.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/hexokinase.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/vim-ruby.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/indentline.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/aerial.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/rainbow.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/echodoc.vim')
execute 'source' fnameescape(stdpath('config') . '/settings/diffview.vim')

" Mappings
execute 'source' fnameescape(stdpath('config') . '/settings/allkey.vim')

" Generic configs
execute 'source' fnameescape(stdpath('config') . '/settings/cursorline.vim')

" Neovide
execute 'source' fnameescape(stdpath('config') . '/settings/neovide.vim')

" Custom plugins
execute 'source' fnameescape(stdpath('config') . '/plugins/hlsearch.vim')
execute 'source' fnameescape(stdpath('config') . '/plugins/nicefold.vim')

lua <<LUA
require'./settings/notify'
require'./settings/tree-explorer'
require'./settings/LSP'
require'./settings/telescope'
require'./settings/git_conflict'
require'./settings/lualine'
require'./settings/dap'
LUA

colorscheme nord

let b:local_override_file = fnameescape($HOME . '/.vimrc_local')
if filereadable(b:local_override_file)
  execute 'source' b:local_override_file
endif

set secure
