" Nord colord fixes stolen from
" https://github.com/ArifRoktim/dotfiles/blob/a43029cc92fd57c071842cfb1da49f5b1bd74986/nvim/.config/nvim/init.vim#L227
if pac#loaded('nord-vim')
  augroup nord-overrides
    autocmd!
    autocmd ColorScheme nord highlight Comment guifg=#7b88a1 gui=bold
    autocmd ColorScheme nord highlight Folded guifg=#7b88a1
    autocmd ColorScheme nord highlight FoldColumn guifg=#7b88a1
    autocmd ColorScheme nord highlight Conceal guifg=#7b88a1 guibg=bg
    autocmd ColorScheme nord highlight CocHighlightText guibg=#434C5E
  augroup END

  if &termguicolors
    let g:nord_uniform_diff_background = 1
    let g:nord_italic = 1
    let g:nord_underline = 1
  endif

  colorscheme nord
endif
