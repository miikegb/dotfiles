return {
  "nvim-tree/nvim-tree.lua",
  config = function(_, opts)
    require("nvim-tree").setup(opts)
    local function set_highlights()
      vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    end
    set_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })
  end,
}
