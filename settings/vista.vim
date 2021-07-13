let g:vista_default_executive = 'ctags'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1

let g:vista_executive_for = {
  \ 'go': 'ctags',
  \ 'javascript': 'nvim_lsp',
  \ 'javascript.jsx': 'nvim_lsp',
  \ 'python': 'ctags',
  \ 'ruby': 'nvim_lsp',
  \ }

let g:vista_ctags_cmd = {
  \ 'go': 'gotags',
  \ }
