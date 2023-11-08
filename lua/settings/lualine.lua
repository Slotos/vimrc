function CurrentFunction()
  return ''
end

if vim.fn['pac#loaded']('nvim-treesitter') then
  local treesitter = require('nvim-treesitter')

  function CurrentFunction()
    treesitter.statusline({ indicator_size = 30, type_patterns = { 'class', 'module', 'function', 'method' } })
  end
end

function ShortName()
  return vim.fn.pathshorten(
    vim.fn.fnamemodify(
      vim.fn.expand("%"),
      ":~:."
    ),
    3
  )
end

local getDevIcon = (function () return nil end)
if vim.fn['pac#loaded']('nvim-web-devicons') then
  local devicons = require'nvim-web-devicons'
  getDevIcon = function(filename, filetype, extension)
    local icon, color
    local devhl = filetype

    if filetype == 'TelescopePrompt' then
      icon, color = devicons.get_icon_color('telescope', { default = true })
    elseif filetype == 'fugitive' then
      icon, color =  devicons.get_icon_color('git', { default = true })
    elseif filetype == 'vimwiki' then
      icon, color =  devicons.get_icon_color('markdown', { default = true })
    elseif buftype == 'terminal' then
      icon, color =  devicons.get_icon_color('zsh', { default = true })
    else
      icon, color =  devicons.get_icon_color(filename, extension, { default = true })
      _, devhl =  devicons.get_icon(filename, extension, { default = true })
    end

    return icon, color, devhl
  end
end

if vim.fn['pac#loaded']('lualine.nvim') then
  local lsp_progress = {}

  local concat_lsp_progress = function()
    local out = {}
    for _, v in pairs(lsp_progress) do
      out[#out+1] = string.gsub(v, "%%", "%%%%")
    end
    return table.concat(out, "; ") or ""
  end

  -- Prior to this event, handling of progress messages is messy
  -- I use neovim-nightly, this is here to not explode my configuration when
  -- I run tests on plugins using neovim stable
  if vim.fn.exists('##LspProgress') == 1 then
    vim.api.nvim_create_autocmd('LspProgress', {
      callback = function(args)
        -- {
        --   client_id = 1,
        --   result = {
        --     token = "indexing-progress",
        --     value = {
        --       kind = "begin",
        --       message = "0% completed",
        --       percentage = 0,
        --       title = "Ruby LSP: indexing files"
        --     }
        --   }
        local data = args.data
        local client = vim.lsp.get_client_by_id(data.client_id)
        if not client then return end

        if data.result.value.kind == "end" then
          lsp_progress[data.client_id] = nil
        else
          lsp_progress[data.client_id] = string.format("%s: %s", client.name, data.result.value.message or data.result.value.title)
        end
        require("lualine").refresh()
      end,
    })
  end

  local lualine_highlight = require'lualine.highlight'

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
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {},
      always_divide_middle = false, -- this really needs a separate tabline option
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { ShortName, vim.fn['pac#loaded']('aerial.nvim') and 'aerial' or CurrentFunction },
      lualine_x = { concat_lsp_progress, 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { ShortName, vim.fn['pac#loaded']('aerial.nvim') and 'aerial' or CurrentFunction },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'location' },
      lualine_z = {}
    },
    tabline = {
      lualine_a = {
        {
          'tabs',
          max_length = vim.o.columns,
          mode = 1,
          icons_enabled = true,
          modification_icons_enabled = true,
          icon = {
            align = 'right',
            use_default = true
          },
          fmt = function(name, context)
            local win_handle = vim.api.nvim_tabpage_get_win(context.tabId)
            local buf_handle = vim.api.nvim_win_get_buf(win_handle)

            -- sequential tab number
            local status = {'' .. context.tabnr .. '.'}

            -- devicon (extremely hacky, and definitely slow, but with lualine
            --          not exposing handy highlight caching functions, I'll need
            --          to deal with caching myself, but I'm lazy and this too shall pass)
            local filename = vim.fn.expand('#'..buf_handle..':t')
            local filetype = vim.api.nvim_buf_get_option(buf_handle, 'filetype')
            local extension = vim.fn.expand('#'..buf_handle..':e')
            local devicon, fg, devhl = getDevIcon(filename, filetype, extension)
            if devicon then
              local h = require'color_helpers'
              local tab_hlgroup = lualine_highlight.component_format_highlight(context.highlights[(context.current and 'active' or 'inactive')])
              local bg = h.extract_highlight_colors(tab_hlgroup:sub(3, -2), 'bg')

              -- can't use this due to a bug - https://github.com/nvim-lualine/lualine.nvim/pull/677
              -- one day I will figure out why tests fail on master for me locally (probably they load local config, saw that in other places)
              -- and I will get that code covered and merged; meanwhile, deal with it Gordian knot style
              -- local highlight = lualine_highlight.create_component_highlight_group({fg = fg, bg = bg}, "", context, false)

              local hl = h.create_component_highlight_group({bg = bg, fg = fg}, "local_" .. devhl .. "_tab_" .. (context.current and 'active' or 'inactive'))
              table.insert(
                status,
                -- '%#' .. hl .. '#' .. devicon .. tab_hlgroup
                {highlight = "%#" .. hl .. "#", text = devicon .. " "}
              )
            end

            -- tab name as provided by lualine
            table.insert(status, {text = name})

            -- modified and modifiable symbols
            if vim.api.nvim_buf_get_option(buf_handle, 'modified') then table.insert(status, {text = ' \u{f448} '}) end
            if not vim.api.nvim_buf_get_option(buf_handle, 'modifiable') then table.insert(status, {text = ' \u{e672} '}) end

            return status
          end,
        }
      },
    },
    extensions = { 'fugitive', 'quickfix', neoterm_extension },
  }

  require 'lualine'.setup(lualine_config)
end
