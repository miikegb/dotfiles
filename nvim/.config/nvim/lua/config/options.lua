-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.winborder = "rounded"

local orig_ofp = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  vim.notify("border=" .. tostring(opts.border), vim.log.levels.INFO)
  return orig_ofp(contents, syntax, opts)
end
