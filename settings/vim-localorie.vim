if pac#loaded('vim-localorie')
  augroup Localorie
    autocmd!
    autocmd CursorMoved *.yml echo localorie#expand_key()
  augroup END
endif
