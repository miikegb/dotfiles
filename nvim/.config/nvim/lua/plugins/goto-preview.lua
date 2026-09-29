-- Peek a definition's full body in a float, without leaving the current buffer.
return {
  "rmagatti/goto-preview",
  dependencies = { "rmagatti/logger.nvim" },
  event = "LspAttach",
  opts = {
    border = "rounded",
  },
  keys = {
    { "gp", function() require("goto-preview").goto_preview_definition() end, desc = "Peek Definition" },
    { "gP", function() require("goto-preview").close_all_win() end, desc = "Close Peek Windows" },
  },
}
