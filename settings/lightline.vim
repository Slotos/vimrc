augroup LightlineColorsheme
  autocmd!
  autocmd ColorScheme * call UpdateLightlineTheme()

  autocmd OptionSet background call UpdateLightlineTheme()
augroup END

function! UpdateLightlineTheme() abort
  let l:known_good_themes = ['nord', 'nordlight', 'iceberg', 'dogrun', 'tokyonight', 'sialoquent', 'oceanicnext', 'elly', 'blue-moon', 'PaperColor']
  let l:colors_name = get(g:, 'colors_name')
  let $BAT_THEME = 'base16' " works ok with any colors

  if index(l:known_good_themes, l:colors_name) != -1
    let g:lightline.colorscheme = l:colors_name
  endif

  " Special cases
  if l:colors_name == 'nord'
    let $BAT_THEME = 'nord'
  elseif l:colors_name == 'iceberg'
    let g:lightline.colorscheme = (&bg == 'light' ? 'iceberg' : 'icebergDark')
  elseif l:colors_name == 'deep-space'
    let g:lightline.colorscheme = 'deepspace'
  elseif l:colors_name == 'two-firewatch'
    let g:lightline.colorscheme = 'twofirewatch'
  end

  call LightlineReload()
endfunction

if pac#loaded('nvim-treesitter')
  function! CurrentFunction()
    let l:tree_sitter_indicator = nvim_treesitter#statusline({'indicator_size': 50, 'type_patterns': ['class', 'module', 'function', 'method']})
    if tree_sitter_indicator is v:null
      return ''
    endif
    return tree_sitter_indicator
  endfunction
else
  function! CurrentFunction()
    return ''
  endfunction
end

if pac#loaded('lsp-status.nvim')
  lua << LUA
  local lsp_status = require'lsp-status'
  _G.lsp_status_progress = lsp_status.status_progress
LUA
  function! LspProgress()
    return v:lua.lsp_status_progress()
  endfunction
else
  function! LspProgress()
    return ''
  endfunction
endif

function! ShortName()
    return pathshorten(expand('%'))
endfunction

function! LightlineModified() abort
    return &modifiable && &modified ? "\uf448" : ''
endfunction

function! LightlineTabModified(n) abort
    let winnr = tabpagewinnr(a:n)
    return gettabwinvar(a:n, winnr, '&modified') ? "\uf448" : gettabwinvar(a:n, winnr, '&modifiable') ? '' : "\uf83d"
endfunction

function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

let g:lightline = get(g:, 'lightline', {})
let g:lightline.colorscheme = 'nord'

let g:lightline.active = {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'shortname', 'method', 'modified' ] ],
            \   'right': [
            \              [ 'lineinfo' ],
            \              [ 'percent' ],
            \              [ 'fileformat', 'fileencoding', 'filetype' ],
            \              [ 'lsp_progress' ] ],
            \ }

let g:lightline.inactive = {
            \ 'left': [ [], [ 'gitbranch', 'readonly', 'shortname' ] ],
            \ 'right': [ [ 'lineinfo' ],
            \            [ 'percent' ],
            \            [ 'filetype' ] ]
            \ }

let g:lightline.component_function = get(g:lightline, 'component_function', {})
let g:lightline.component_function.gitbranch = 'FugitiveHead'
let g:lightline.component_function.method = 'CurrentFunction'
let g:lightline.component_function.shortname = 'ShortName'
let g:lightline.component_function.modified = 'LightlineModified'
let g:lightline.component_function.lsp_progress = 'LspProgress'

let g:lightline.component_type = {
           \   'linter_checking': 'left',
           \   'linter_warnings': 'warning',
           \   'linter_errors': 'error',
           \   'linter_ok': 'left',
           \ }

let g:lightline.separator = { 'left': "\ue0b0", 'right': "\ue0b2" }
let g:lightline.subseparator = { 'left': "\ue0b1", 'right': "\ue0b3" }
let g:lightline.enable = { 'tabline': 1 }
let g:lightline.tab = {
           \   'active': ['tabnum', 'filetype', 'filename', 'modified'],
           \   'inactive': ['tabnum', 'filetype', 'filename', 'modified'],
           \ }

let g:lightline.tab_component_function = get(g:lightline, 'tab_component_function', {})
let g:lightline.tab_component_function.modified = 'LightlineTabModified'
