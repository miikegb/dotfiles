-- markdownlint-cli2 only finds config files in the file's directory and its
-- ancestors, so a home-wide default needs to be passed explicitly.
return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.linters = opts.linters or {}
    opts.linters["markdownlint-cli2"] = {
      args = { "--config", vim.fn.expand("~/.config/markdownlint/config.yaml"), "-" },
    }
  end,
}
