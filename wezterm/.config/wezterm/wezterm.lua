-- WezTerm config mirroring ghostty/.config/ghostty/config.
-- Theme lines are managed by the `theme` tool; edit them there, not here.
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- --- Theme: follow the macOS appearance, like ghostty's `light:…,dark:…` pair ---
local dark_scheme = "rose-pine"
local light_scheme = "rose-pine-dawn"

local function scheme_for_appearance()
  local appearance = wezterm.gui and wezterm.gui.get_appearance() or "Dark"
  if appearance:find("Dark") then
    return dark_scheme
  end
  return light_scheme
end
config.color_scheme = scheme_for_appearance()

-- --- Window (ghostty: macos-titlebar-style = hidden, opacity 0.9, blur) ---
config.window_decorations = "RESIZE" -- no title bar, still resizable from the edges
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

-- --- Font ---
config.font = wezterm.font("Hurmit Nerd Font")
config.font_size = 16

-- --- Cursor (ghostty: cursor-style = block; shell integration leaves it alone) ---
config.default_cursor_style = "SteadyBlock"

-- Not mirrored: ghostty's quick terminal (ctrl+alt+shift+8) and the cursor
-- shader have no WezTerm equivalent.

return config
