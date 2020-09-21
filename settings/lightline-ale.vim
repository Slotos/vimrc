if pac#loaded('ale')
  let g:lightline = get(g:, 'lightline', {})
  let g:lightline.component_expand = get(g:lightline, 'component_expand', {})
  let g:lightline.component_expand.linter_checking = 'lightline#ale#checking'
  let g:lightline.component_expand.linter_warnings = 'lightline#ale#warnings'
  let g:lightline.component_expand.linter_errors   = 'lightline#ale#errors'
  let g:lightline.component_expand.linter_ok       = 'lightline#ale#ok'
end
