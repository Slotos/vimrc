-- stolen from runtime/lua/vim/_inspector.lua
local read_pos = function()
  local items = vim.inspect_pos()

  local lines = { {} }

  local function append(str, hl)
    table.insert(lines[#lines], { str, hl })
  end

  local function nl()
    table.insert(lines, {})
  end

  local function item(data, comment)
    append('  - ')
    append(data.hl_group, data.hl_group)
    append(' ')
    if data.hl_group ~= data.hl_group_link then
      append('links to ', 'MoreMsg')
      append(data.hl_group_link, data.hl_group_link)
      append(' ')
    end
    if comment then
      append(comment, 'Comment')
    end
    nl()
  end

  -- treesitter
  if #items.treesitter > 0 then
    append('Treesitter', 'Title')
    nl()
    for _, capture in ipairs(items.treesitter) do
      item(capture, capture.lang)
    end
    nl()
  end

  -- semantic tokens
  if #items.semantic_tokens > 0 then
    append('Semantic Tokens', 'Title')
    nl()
    local sorted_marks = vim.fn.sort(items.semantic_tokens, function(left, right)
      local left_first = left.opts.priority < right.opts.priority
        or left.opts.priority == right.opts.priority and left.opts.hl_group < right.opts.hl_group
      return left_first and -1 or 1
    end)
    for _, extmark in ipairs(sorted_marks) do
      item(extmark.opts, 'priority: ' .. extmark.opts.priority)
    end
    nl()
  end

  -- syntax
  if #items.syntax > 0 then
    append('Syntax', 'Title')
    nl()
    for _, syn in ipairs(items.syntax) do
      item(syn)
    end
    nl()
  end

  -- extmarks
  if #items.extmarks > 0 then
    append('Extmarks', 'Title')
    nl()
    for _, extmark in ipairs(items.extmarks) do
      if extmark.opts.hl_group then
        item(extmark.opts, extmark.ns)
      else
        append('  - ')
        append(extmark.ns, 'Comment')
        nl()
      end
    end
    nl()
  end

  if #lines[#lines] == 0 then
    table.remove(lines)
  end

  local chunks = {}
  for _, line in ipairs(lines) do
    vim.list_extend(chunks, line)
    table.insert(chunks, { '\n' })
  end

  return chunks
end

local local_ts_namespace = vim.api.nvim_create_namespace("")

vim.keymap.set(
  {"n"},
  "<localleader>h",
  function()
    -- @todo format into a floating window (nvim-open-win)
    local inspected = read_pos()

    if #inspected == 0 then return end

    local bufnr = vim.api.nvim_create_buf(false, true)
    if bufnr == 0 then return end

    local col, row = 0, 0
    local max_width, width = 0, 0

    for _, chunk in ipairs(inspected) do
      local text, highlight = unpack(chunk)
      local text_len = string.len(text)

      if text == "\n" then
        max_width = math.max(width, max_width)
        width = 0

        col = 0
        row = row + 1

        -- insert a new line
        vim.api.nvim_buf_set_lines(bufnr, row, row, false, {""})
      else
        width = width + text_len

        local new_col = col + text_len

        vim.api.nvim_buf_set_text(bufnr, row, col, row, col, { text })

        if highlight then
          vim.api.nvim_buf_add_highlight(bufnr, local_ts_namespace, highlight, row, col, new_col)
        end

        col = new_col
      end
    end

    local winnr = vim.api.nvim_open_win(bufnr, false, {
      relative = "cursor", row = 1, col = 0,
      width = max_width, height = row + 1, style = "minimal",
      border = {" ", " " ," ", " ", " ", " ", " ", " "},
      focusable = false, noautocmd = true
    })

    if winnr == 0 then return end

    -- Ensure we close the window when moving around
    local augroup = vim.api.nvim_create_augroup('preview_window_' .. winnr, {
      clear = true,
    })

    local lookup_bufnr = vim.api.nvim_get_current_buf()

    -- close the preview window when entered a buffer that is not
    -- the floating window buffer or the buffer that spawned it
    vim.api.nvim_create_autocmd('BufEnter', {
      group = augroup,
      callback = function(args)
        if args.buf == bufnr or args.buf == lookup_bufnr then return end

        vim.api.nvim_del_augroup_by_id(augroup)
        vim.schedule(function()
          pcall(vim.api.nvim_win_close, winnr, true)
        end)
      end,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertCharPre' }, {
      group = augroup,
      buffer = lookup_bufnr,
      callback = function()
        vim.api.nvim_del_augroup_by_id(augroup)
        vim.schedule(function()
          pcall(vim.api.nvim_win_close, winnr, true)
        end)
      end,
    })
  end,
  { silent = true, desc = "Inspect contents at the cursor position" }
)

local treesitter_grp = vim.api.nvim_create_augroup('Treesitter', {clear = true})
vim.api.nvim_create_autocmd('FileType', {
  group = treesitter_grp,
  callback = function() pcall(vim.treesitter.start) end,
})

if vim.fn['pac#loaded']('nvim-treesitter') then
  if vim.fn['pac#loaded']('nvim-ts-context-commentstring') then
    require('ts_context_commentstring').setup {}
  end

  require'nvim-treesitter.configs'.setup {
    indent = {
      enable = true,
    },
    matchup = {
      enable = true,
      include_match_words = false,
    },
  }

  vim.api.nvim_create_autocmd({ 'FileType' },
    {
      pattern = 'ruby,eruby,javascript,lua,go,elixir,vim,typescript,markdown,typescriptreact',
      group = treesitter_grp,
      callback = function()
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
      desc = 'Set tree-sitter folding for chosen filetypes',
    }
  )
end
