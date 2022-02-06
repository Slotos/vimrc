" Theme

" Enable 256 color terminal
set t_Co=256

" Enable true color
if has('termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" Highlight yank
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=150}
augroup END

" tokyonight.nvim
let g:tokyonight_style = 'night'
let g:tokyonight_italic_functions = v:true
let g:tokyonight_italic_variables = v:true

" nord.nvim
let g:nord_contrast = v:true
let g:nord_borders = v:true

" calvera-darl.nvim
let g:calvera_italic_comments = 1
let g:calvera_italic_keywords = 1
let g:calvera_italic_functions = 1
let g:calvera_contrast = 1

" moonlight.nvim
let g:moonlight_italic_comments = v:true
let g:moonlight_italic_keywords = v:true
let g:moonlight_italic_functions = v:true
let g:moonlight_italic_variables = v:false
let g:moonlight_contrast = v:true
let g:moonlight_borders = v:false 
let g:moonlight_disable_background = v:false
