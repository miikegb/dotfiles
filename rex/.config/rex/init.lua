-- ~/.config/rex/init.lua  (stowed from ~/dotfiles/rex)
-- Navigation mirroring ~/dotfiles/herdr/.config/herdr/config.toml
-- herdr workspaces -> Rex sessions, tabs -> tabs, panes -> panes
-- After editing: rex config check && rex config reload

local P = "ctrl+space>"   -- herdr prefix = "ctrl+space"
local dirs = { h = "left", j = "down", k = "up", l = "right" }
local arrows = { left = "left", down = "down", up = "up", right = "right" }

-- Press the prefix twice to send it through to the terminal
rex.bind(P .. "ctrl+space", "pane.send_key", { key = "ctrl+space" })

---------------------------------------------------------------------------
-- Moving between panes
---------------------------------------------------------------------------
-- ctrl+h/j/k/l: seamless nvim <-> Rex navigation (pairs with rex-nav.nvim).
-- rex-nav.nvim titles the terminal "nvim · <file>". When the focused pane's
-- title starts with "nvim", the key goes to nvim (which moves between splits
-- and calls `rex focus <dir>` at an edge). Otherwise Rex moves focus itself.
-- If anything fails, the key falls through to the terminal.
local function running_nvim()
  local res = rex.block.call("com.superlogical.terminal", "title", {})
  local title = type(res) == "table" and res.title or ""
  return title:find("^nvim") ~= nil
end

-- The API docs describe directions as left/right/above/below; try both spellings.
local alt_dir = { up = "above", down = "below" }
local function focus(dir)
  local res = rex.session.focus_direction{ direction = dir }
  if res == nil and alt_dir[dir] then
    res = rex.session.focus_direction{ direction = alt_dir[dir] }
  end
  return res ~= nil
end

for key, dir in pairs(dirs) do
  rex.bind("ctrl+" .. key, function(ctx, ev)
    if running_nvim() then return false end
    return focus(dir)
  end)
end

for key, dir in pairs(dirs) do
  rex.bind("alt+" .. key, "pane.focus." .. dir)          -- alt+h/j/k/l
end
for key, dir in pairs(arrows) do
  rex.bind(P .. key, "pane.focus." .. dir)               -- prefix+arrows
end
rex.bind(P .. "tab", "pane.focus_next")                  -- prefix+tab
rex.bind(P .. "shift+tab", "pane.focus_previous")        -- prefix+shift+tab

---------------------------------------------------------------------------
-- Resizing panes
---------------------------------------------------------------------------
for key, dir in pairs(dirs) do
  rex.bind(P .. key, "pane.resize", { direction = dir })          -- prefix+h/j/k/l
  rex.bind("alt+shift+" .. key, "pane.resize", { direction = dir }) -- alt+shift+h/j/k/l
end

-- prefix+r: resize mode, h/j/k/l repeatedly, esc/enter to leave
rex.mode("resize", { exclusive = true })
rex.bind(P .. "r", "client.mode.enter", { name = "resize" })
for key, dir in pairs(dirs) do
  rex.bind("resize/" .. key, "pane.resize", { direction = dir })
  rex.bind("resize/shift+" .. key, "pane.resize", { direction = dir, amount = 15 })
end
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")

---------------------------------------------------------------------------
-- Moving panes
---------------------------------------------------------------------------
for key, dir in pairs(dirs) do
  rex.bind(P .. "shift+" .. key, "pane.move." .. dir)    -- prefix+shift+h/j/k/l
end

---------------------------------------------------------------------------
-- Splitting, zooming, closing
---------------------------------------------------------------------------
rex.bind(P .. "shift+\\", "pane.split.right")            -- prefix+|
rex.bind(P .. "v", "pane.split.right")                   -- prefix+v
rex.bind(P .. "-", "pane.split.down")                    -- prefix+-
rex.bind(P .. "m", "pane.zoom")                          -- prefix+m
rex.bind(P .. "z", "pane.zoom")                          -- prefix+z
rex.bind(P .. "f", "pane.zoom")                          -- prefix+f
rex.bind(P .. "x", "pane.close")                         -- prefix+x

---------------------------------------------------------------------------
-- Tabs
---------------------------------------------------------------------------
rex.bind(P .. "c", "client.tab.new")
rex.bind(P .. "n", "client.tab.next")
rex.bind(P .. "p", "client.tab.previous")
for i = 1, 9 do
  rex.bind(P .. "[Digit" .. i .. "]", "client.tab.goto", { index = i })
end
rex.bind("alt+i", "client.tab.move.backward")
rex.bind("alt+o", "client.tab.move.forward")
rex.bind(P .. "shift+t", "client.tab.rename")
rex.bind(P .. "shift+x", "client.tab.close")

---------------------------------------------------------------------------
-- Workspaces (Rex sessions)
---------------------------------------------------------------------------
rex.bind(P .. "w", "session.switch")
rex.bind(P .. "g", "session.switch")
rex.bind(P .. "shift+n", "session.new")
rex.bind(P .. "shift+w", "session.rename")
rex.bind(P .. "shift+d", "session.close")
rex.bind(P .. "b", "client.sidebar.toggle")

---------------------------------------------------------------------------
-- Other
---------------------------------------------------------------------------
rex.bind(P .. "shift+/", "client.palette.toggle")        -- prefix+?
rex.bind(P .. "s", "client.settings")                    -- prefix+s
rex.bind(P .. "shift+r", "client.config.reload")         -- prefix+shift+r
