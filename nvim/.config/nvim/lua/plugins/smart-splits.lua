-- Ctrl+h/j/k/l moves between neovim splits and Rex/herdr/tmux panes (via rex-nav)
return {
  "mrjones2014/smart-splits.nvim",
  -- v3 dropped the herdr backend; v2 still hands off to herdr panes at split edges
  tag = "v2.1.1-final",
  lazy = false,
  opts = {},
  keys = {
    { "<c-h>", function() require("rex-nav").move("left") end, desc = "Move to left split/pane" },
    { "<c-j>", function() require("rex-nav").move("down") end, desc = "Move to lower split/pane" },
    { "<c-k>", function() require("rex-nav").move("up") end, desc = "Move to upper split/pane" },
    { "<c-l>", function() require("rex-nav").move("right") end, desc = "Move to right split/pane" },
    { "<c-\\>", function() require("smart-splits").move_cursor_previous() end, desc = "Move to previous split/pane" },
  },
}
