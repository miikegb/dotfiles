-- LazyVim's markdown extra strips heading icons, signs and checkboxes.
-- Restore render-markdown's default glyphs on top of its highlighted lines.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    heading = {
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      -- "inline" puts the icon flush left; "overlay" pads it to the hashes' width.
      position = "overlay",
    },
    code = { sign = true },
    checkbox = { enabled = true },
  },
}
