if pac#loaded('nvim-treesitter')
  function! CurrentFunction()
    let l:tree_sitter_indicator = nvim_treesitter#statusline({
          \'indicator_size': 30,
          \'type_patterns': ['class', 'module', 'function', 'method'],
          \})
    if tree_sitter_indicator is v:null
      return ''
    endif
    return tree_sitter_indicator
  endfunction
else
  function! CurrentFunction()
    return ''
  endfunction
end

if pac#loaded('lsp-status.nvim')
  lua << LUA
  local lsp_status = require'lsp-status'
  _G.lsp_status_progress = lsp_status.status_progress
LUA
  function! LspProgress()
    return v:lua.lsp_status_progress()
  endfunction
else
  function! LspProgress()
    return ''
  endfunction
endif

function! ShortName()
    return pathshorten(expand('%')) . BuffModificationStatus()
endfunction

function! BuffModificationStatus() abort
    return &modifiable ? &modified ? " \uf448" : '' : " \uf83d"
endfunction

lua << LUA
if vim.fn['pac#loaded']('lualine.nvim') then
  local aerial_extension = vim.deepcopy(require 'lualine.extensions.symbols-outline')
  aerial_extension.filetypes = { 'aerial' }

  local neoterm_extension = {
    sections = {
      lualine_a = { (function() return 'NeoTerm #' .. vim.b.neoterm_id end) },
      },
    filetypes = { 'neoterm' }
    }


  local lualine_config = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = false, -- this really needs a separate tabline option
      },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'ShortName', vim.fn['pac#loaded']('aerial.nvim') and 'aerial' or 'CurrentFunction'},
      lualine_x = {'LspProgress', 'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
      },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
      },
    tabline = {
      },
    extensions = {'fugitive', 'nvim-tree', 'quickfix', aerial_extension, neoterm_extension},
    }

  require'lualine'.setup(lualine_config)

  if vim.fn['pac#loaded']('luatab.nvim') then
    function _G.GenerateTabLineSeparatorHls()
      local bg, fg, hl
      local h = require'color_helpers'
      local dict = {
        {TabLine = 'TabLineSel'},
        {TabLineSel = 'TabLine'},
        {TabLine = 'TabLineFill'},
        {TabLineSel = 'TabLineFill'},
        }

      for _, tab_transition in pairs(dict) do
        for previous_tab_hl, next_tab_hl in pairs(tab_transition) do
          fg = h.extract_highlight_colors(previous_tab_hl, 'bg') or 'NONE'
          bg = h.extract_highlight_colors(next_tab_hl, 'bg') or 'NONE'
          hl = h.create_component_highlight_group({bg = bg, fg = fg}, previous_tab_hl .. '_' .. next_tab_hl)
        end
      end
    end

    vim.api.nvim_command('augroup TabLineSeparators')
    vim.api.nvim_command('autocmd!')
    vim.api.nvim_command('autocmd ColorScheme * call v:lua.GenerateTabLineSeparatorHls()')
    vim.api.nvim_command('autocmd OptionSet background call v:lua.GenerateTabLineSeparatorHls()')
    vim.api.nvim_command('augroup END')

    local luatab_config = {
      modified = function(bufnr)
        local status = {}

        if vim.fn.getbufvar(bufnr, '&modified') == 1 then table.insert(status, '\u{f448}') end
        if vim.fn.getbufvar(bufnr, '&modifiable') ~= 1 then table.insert(status, '\u{f83d}') end
        table.insert(status, '')

        return table.concat(status, ' ')
      end,
      windowCount = function(index) -- hijack to show tab number
        return index .. '. '
      end,
      separator = function(index)
        local fg, bg, hl
        local separator_char = lualine_config.options.section_separators.left
        local invert_separator = false

        if index == (vim.fn.tabpagenr() - 1) then -- inactive tab before active tab
          hl = 'luatab_TabLine_TabLineSel'
        elseif index == vim.fn.tabpagenr() and index == vim.fn.tabpagenr('$') then -- active final tab
          hl = 'luatab_TabLineSel_TabLineFill'
        elseif index == vim.fn.tabpagenr() then -- active but not final tab
          hl = 'luatab_TabLineSel_TabLine'
        elseif index == vim.fn.tabpagenr('$') then -- final inactive tab
          hl = 'luatab_TabLine_TabLineFill'
        else -- inactive tab before inactive tab
          hl = 'TabLine'
          separator_char = lualine_config.options.component_separators.left
        end

        -- return (index < vim.fn.tabpagenr('$') and '%#' .. hl .. '#' .. separator_char or '')
        return '%#' .. hl .. '#' .. separator_char
      end,
      }

    require'luatab'.setup(luatab_config)
  end
end

LUA
