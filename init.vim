" Note: NVIM is always nocompatible

let $VIM_CONFIG_DIR = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let $VIM_DATA_DIR =
    \ expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache').'/vim')

" ensure vim config path is first in packpath
" needed for minpac
if &packpath !~# $VIM_CONFIG_DIR
  set packpath^=$VIM_CONFIG_DIR
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
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/general.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/style.vim')

" plugins
execute 'source' fnameescape($VIM_CONFIG_DIR . '/pac.vim')

" LSP configuration and completion
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/LSP.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/nvim-cmp.vim')

" plugin configurations
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/gitsigns.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/nvim-tree.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/nvim-treesitter.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/lualine.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/nord.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/tokyonight.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/neoterm.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/vim-choosewin.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/hexokinase.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/telescope.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/vim-json.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/vim-ruby.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/indentline.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/aerial.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/rainbow.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/echodoc.vim')

" Mappings
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/allkey.vim')

" Generic configs
execute 'source' fnameescape($VIM_CONFIG_DIR . '/settings/cursorline.vim')

" Custom plugins
execute 'source' fnameescape($VIM_CONFIG_DIR . '/plugins/difftools.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/plugins/hlsearch.vim')
execute 'source' fnameescape($VIM_CONFIG_DIR . '/plugins/nicefold.vim')

let b:local_override_file = fnameescape($HOME . '/.vimrc_local')
if filereadable(b:local_override_file)
  execute 'source' b:local_override_file
endif

" Neovide
" Paste with Command+V
imap <silent> <D-v> <C-r>*
cmap <D-v> <C-r>*

let g:neovide_input_use_logo=v:true
let g:neovide_cursor_antialiasing=v:true
let g:neovide_cursor_vfx_mode = "railgun"
let g:neovide_cursor_vfx_particle_density=0
" END Neovide

set secure
