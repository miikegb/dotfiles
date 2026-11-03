-- Ctrl+h/j/k/l across nvim splits and Rex panes (falls back to smart-splits outside Rex)
return {
  dir = vim.fn.stdpath("config") .. "/local-plugins/rex-nav.nvim",
  name = "rex-nav.nvim",
  lazy = false,
  opts = {},
}
