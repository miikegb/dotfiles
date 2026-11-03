-- rex-nav.nvim: move between nvim splits and Rex panes with the same keys.
--
-- Inside Rex ($REX_BLOCK is set):
--   * moves between nvim splits; at an edge, runs `rex focus <dir>` so focus
--     continues into the neighbouring Rex pane.
--   * sets the terminal title to "nvim · <file>" so Rex's ctrl+h/j/k/l binding
--     (~/.config/rex/init.lua) knows to hand the key to nvim.
-- Outside Rex: delegates to smart-splits.nvim (herdr, tmux, ...) if installed,
-- else plain window movement.

local M = {}

M.config = {
  cmd = "rex",          -- the Rex CLI
  title = "nvim · %t",  -- must start with "nvim" to match the Rex binding
  wrap = false,         -- wrap around at the outer edge of the Rex window
}

local wincmd = { left = "h", down = "j", up = "k", right = "l" }

function M.in_rex()
  return vim.env.REX_BLOCK ~= nil and vim.env.REX_BLOCK ~= ""
end

local function rex_focus(dir)
  local argv = { M.config.cmd, "focus", dir }
  if M.config.wrap then table.insert(argv, "--wrap") end
  local ok, err = pcall(vim.system, argv, { text = true }, function(res)
    if res.code ~= 0 then
      vim.schedule(function()
        vim.notify(("rex-nav: `%s` failed: %s"):format(table.concat(argv, " "),
          vim.trim(res.stderr or "")), vim.log.levels.WARN)
      end)
    end
  end)
  if not ok then
    vim.notify("rex-nav: could not run " .. M.config.cmd .. ": " .. tostring(err), vim.log.levels.WARN)
  end
end

--- Move left/down/up/right across nvim splits, then into Rex panes.
function M.move(dir)
  if not M.in_rex() then
    local ok, ss = pcall(require, "smart-splits")
    if ok then return ss["move_cursor_" .. dir]() end
    return vim.cmd("wincmd " .. wincmd[dir])
  end
  local before = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. wincmd[dir])
  if vim.api.nvim_get_current_win() == before then
    rex_focus(dir)
  end
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  if M.in_rex() and M.config.title then
    vim.o.title = true
    vim.o.titlestring = M.config.title
    -- On exit, leave a title that no longer starts with "nvim" (like a shell
    -- would show), so Rex stops passing ctrl+h/j/k/l through to this pane.
    if vim.o.titleold == "" then
      local function set_old() vim.o.titleold = vim.fn.fnamemodify(vim.fn.getcwd(), ":~") end
      set_old()
      vim.api.nvim_create_autocmd("DirChanged", { callback = set_old })
    end
  end
  vim.api.nvim_create_user_command("RexNavCheck", function()
    vim.notify(("in Rex: %s | REX_BLOCK=%s | cli: %s | title: %s"):format(
      tostring(M.in_rex()), vim.env.REX_BLOCK or "-",
      vim.fn.exepath(M.config.cmd) ~= "" and vim.fn.exepath(M.config.cmd) or "NOT FOUND",
      vim.o.title and vim.o.titlestring or "(off)"))
  end, { desc = "Show rex-nav status" })
end

return M
