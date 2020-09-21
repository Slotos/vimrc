if pac#loaded('vim-devicons')
  let g:lightline = get(g:, 'lightline', {})
  let g:lightline.component_function = get(g:lightline, 'component_function', {})

  let g:lightline.component_function.filetype = 'WebDevIconsGetFileTypeSymbol'
  let g:lightline.component_function.fileformat = 'WebDevIconsGetFileFormatSymbol'

  let g:lightline.tab_component_function = get(g:lightline, 'tab_component_function', {})
  let g:lightline.tab_component_function.filetype = 'TabDevIconFiletype'

  function! TabDevIconFiletype(n)
    return WebDevIconsGetFileTypeSymbol(lightline#tab#filename(a:n))
  endfunction
endif
