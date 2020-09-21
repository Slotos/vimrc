set cursorline

augroup MyAutoCmd
  " highlight current line in normal mode
  autocmd WinEnter,InsertLeave * set cursorline
  autocmd WinLeave,InsertEnter * set nocursorline
augroup END
