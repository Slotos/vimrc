if pac#loaded('vim-lightline-coc')
  let g:lightline = get(g:, 'lightline', {})
  let g:lightline.active = get(g:lightline, 'active', {})
  let g:lightline.active.right = [[  'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok' ]] + get(g:lightline.active, 'right', []) + [[ 'coc_status' ]]

  call lightline#coc#register()
end
