if vim.fn['pac#loaded']('silicon.lua') then
  local silicon = require('silicon')
  local silicon_utils = require('silicon.utils')

  vim.keymap.set('v', '<Leader>s',  function() silicon.visualise_api({to_clip = true}) end )
  vim.keymap.set('v', '<Leader>sb', function() silicon.visualise_api({to_clip = true, show_buf = true}) end )
  vim.keymap.set('n', '<Leader>s',  function() silicon.visualise_api({to_clip = true, visible = true}) end )

  vim.api.nvim_create_augroup('SiliconRefresh', { clear = true })
  vim.api.nvim_create_autocmd({ 'ColorScheme' },
    {
      group = 'SiliconRefresh',
      callback = function()
        silicon_utils.build_tmTheme()
        silicon_utils.reload_silicon_cache({async = true})
      end,
      desc = 'Reload silicon themes cache on colorscheme switch',
    }
  )

  silicon.setup({
    padHoriz = 20,
    padVert = 20,
    bgColor = '#3330', -- RGBA, with A=0 it's transparent
    shadowBlurRadius = 0,
    windowControls = false,
  })
end
