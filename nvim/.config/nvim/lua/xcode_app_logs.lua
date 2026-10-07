-- A bottom split that tails xcodebuild.nvim's app_logs.log: the stdout/stderr of the
-- app launched from Neovim. The file is rewritten on every launch and appended to
-- while the app runs, so the buffer is reloaded on a timer for as long as it is shown.
local M = {}

local HEIGHT = 12
local POLL_MS = 500

local timer

local function filepath()
  local ok, appdata = pcall(require, "xcodebuild.project.appdata")
  local path = ok and appdata.app_logs_filepath or nil
  return path or (vim.fn.getcwd() .. "/.nvim/xcodebuild/app_logs.log")
end

local function bufnr()
  local buf = vim.fn.bufnr(filepath())
  return buf ~= -1 and buf or nil
end

local function windows()
  local buf = bufnr()
  return buf and vim.fn.win_findbuf(buf) or {}
end

local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

-- Keep the view at the end of the log, unless the cursor is in that window
-- (then you're reading it, so leave the position alone).
local function follow()
  local buf = bufnr()
  if not buf then
    return
  end
  local last = vim.api.nvim_buf_line_count(buf)
  for _, win in ipairs(windows()) do
    if win ~= vim.api.nvim_get_current_win() then
      pcall(vim.api.nvim_win_set_cursor, win, { last, 0 })
    end
  end
end

local function start_timer()
  stop_timer()
  timer = vim.uv.new_timer()
  timer:start(
    POLL_MS,
    POLL_MS,
    vim.schedule_wrap(function()
      local buf = bufnr()
      if not buf or #windows() == 0 then
        stop_timer()
        return
      end
      vim.cmd("silent! checktime " .. buf)
      follow()
    end)
  )
end

function M.is_open()
  return #windows() > 0
end

---Opens the log window without moving the cursor into it.
---@return boolean opened false when there is no log file yet
function M.open()
  if M.is_open() then
    return true
  end

  local path = filepath()
  if vim.fn.filereadable(path) == 0 then
    return false
  end

  local current = vim.api.nvim_get_current_win()
  vim.cmd("botright " .. HEIGHT .. "split " .. vim.fn.fnameescape(path))
  vim.bo.autoread = true
  vim.bo.swapfile = false
  vim.bo.buflisted = false
  vim.wo.winfixheight = true
  vim.wo.wrap = true
  vim.api.nvim_set_current_win(current)

  follow()
  start_timer()
  return true
end

function M.close()
  for _, win in ipairs(windows()) do
    pcall(vim.api.nvim_win_close, win, false)
  end
  stop_timer()
end

function M.toggle()
  if M.is_open() then
    M.close()
  elseif not M.open() then
    vim.notify("No app logs yet: run the app first", vim.log.levels.INFO)
  end
end

return M
