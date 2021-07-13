if pac#loaded('vim-devicons') || pac#loaded('nvim-web-devicons')
  let g:lightline = get(g:, 'lightline', {})
  let g:lightline.component_function = get(g:lightline, 'component_function', {})

  let g:lightline.component_function.filetype = 'WebDevIconsGetFileTypeSymbol'
  let g:lightline.component_function.fileformat = 'WebDevIconsGetFileFormatSymbol'

  let g:lightline.tab_component_function = get(g:lightline, 'tab_component_function', {})
  let g:lightline.tab_component_function.filetype = 'TabDevIconFiletype'

  function! TabDevIconFiletype(n)
    return WebDevIconsGetFileTypeSymbol(lightline#tab#filename(a:n))
  endfunction

  if pac#loaded('nvim-web-devicons')
    lua << LUA
    local webdevicons = require'nvim-web-devicons'
    _G.get_dev_icon = webdevicons.get_icon
LUA

    function! WebDevIconsGetFileTypeSymbols(...)
      return ""
    endfunction

    " a:1 (bufferName), a:2 (isDirectory)
    function! WebDevIconsGetFileTypeSymbol(...)
      if a:0 == 0
        let fileNodeExtension = expand('%:e')
        let fileNode = expand('%:t')
        let isDirectory = 0
      else
        let fileNodeExtension = fnamemodify(a:1, ':e')
        let fileNode = fnamemodify(a:1, ':t')
        let isDirectory = get(a:, 2, 0)
      endif

      if l:isDirectory == 1
        return ''
      else
        let l:result = v:lua.get_dev_icon(fileNode, fileNodeExtension)

        if l:result == v:null
          return ''
        else
          return l:result
        endif
      endif
    endfunction

    function! WebDevIconsGetFileFormatSymbol(...)
      if &fileformat ==? 'dos'
        return ''
      elseif &fileformat ==? 'unix'
        return ''
      elseif &fileformat ==? 'mac'
        return ''
      endif
    endfunction
  end
endif
