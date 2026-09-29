-- noice renders LSP hover/signature help itself, so `winborder` doesn't reach them.
return {
  "folke/noice.nvim",
  opts = {
    presets = {
      lsp_doc_border = true,
    },
  },
}
