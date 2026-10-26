-- Extra colorschemes so every theme in ~/.config/theme/themes can be applied.
-- All lazy: lazy.nvim loads the right one when `:colorscheme` names it.
return {
  { "ellisonleao/gruvbox.nvim", lazy = true, opts = { transparent_mode = true } },
  { "navarasu/onedark.nvim", lazy = true, opts = { transparent = true } },
  { "craftzdog/solarized-osaka.nvim", lazy = true, opts = { transparent = true } },
}
