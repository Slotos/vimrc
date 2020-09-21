scriptencoding utf-8

if pac#loaded('ale')
  let g:ale_sign_column_always = 0
  let g:ale_set_highlights = 1
  let g:ale_sign_error = '😡'
  let g:ale_sign_warning = '😃'
  let g:ale_echo_msg_error_str = 'E'
  let g:ale_echo_msg_warning_str = 'W'
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

  let g:ale_linters = {
        \ 'ruby': ['ruby', 'rubocop', 'solargraph'],
        \ }
endif
