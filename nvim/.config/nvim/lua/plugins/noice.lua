-- noice renders LSP hover/signature help itself, so `winborder` doesn't reach them.
return {
  "folke/noice.nvim",
  opts = {
    presets = {
      lsp_doc_border = true,
    },
    routes = {
      -- pyright re-analyzes on every edit/save; hide its "✓ pyright" progress spam
      {
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            return vim.tbl_get(message.opts, "progress", "client") == "pyright"
          end,
        },
        opts = { skip = true },
      },
    },
  },
}
