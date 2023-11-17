-- Adapted from https://github.com/runiq/neovim-throttle-debounce
-- Copyright (c) 2022 runiq
-- licensed under the MIT License
--
-- MIT License
--
-- Copyright (c) 2023 Dmytro Soltys
-- Copyright (c) 2022 runiq
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local uv = vim.uv or vim.loop

local M = {}

--- Throttles a function on the leading edge.
--- Executes initial call immediately and guarantees execution of the last one.
---
---@param fn (function) Function to throttle
---@param timeout (number) Timeout in ms
---@returns (function, timer) throttled function and a governing timer. Remember to call
---         `timer:close()` once throttling is of no more use, or you will leak memory!
function M.throttle_leading(fn, ms)
  vim.validate({
    fn = { fn, "f" },
    ms = {
      ms,
      function(inner_ms)
        return type(inner_ms) == "number" and inner_ms > 0
      end,
      "number > 0",
    },
  })

  local throttle_timer = uv.new_timer()
  local running = false
  local last_args

  local function wrapped_fn(...)
    if running then
      -- Record arguments of the latest throttled call to run at the end of throttle window
      last_args = { ... }
    else
      -- Run function immediately initially
      running = true
      pcall(vim.schedule_wrap(fn), select(1, ...))

      local throttle_executor
      throttle_executor = function()
        if last_args then
          pcall(vim.schedule_wrap(fn), select(1, unpack(last_args or {})))
          last_args = nil

          -- Schedule next throttle window
          throttle_timer:start(ms, 0, throttle_executor)
        else
          running = false
        end
      end

      -- Schedule execution with the latest arguments at throttling end
      throttle_timer:start(ms, 0, throttle_executor)
    end
  end

  return wrapped_fn, throttle_timer
end

--- Executes wrapped function after a delay
--- Repeadet calls inside a delay window reset the ddelay
---
---@param fn (function) Function to throttle
---@param timeout (number) Timeout in ms
---@returns (function, timer) throttled function and a governing timer. Remember to call
---         `timer:close()` once debouncing is not longer needed, or you will leak memory.
function M.debounce(fn, ms)
  vim.validate({
    fn = { fn, "f" },
    ms = {
      ms,
      function(inner_ms)
        return type(inner_ms) == "number" and inner_ms > 0
      end,
      "number > 0",
    },
  })

  local debounce_timer = uv.new_timer()
  local waiting = false
  local last_args

  local executor = function()
    pcall(vim.schedule_wrap(fn), select(1, unpack(last_args or {})))
    waiting = false
  end

  local function wrapped_fn(...)
    if waiting then
      last_args = { ... }
      debounce_timer:stop()
      debounce_timer:start(ms, 0, executor)
    else
      waiting = true
      debounce_timer:start(ms, 0, executor)
    end
  end

  return wrapped_fn, debounce_timer
end

return M
