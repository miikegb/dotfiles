-- Show the active Python environment (conda / venv) in lualine for Python buffers.
-- Prefers the env picked via :VenvSelect; falls back to the env nvim was launched in.
return {
  "nvim-lualine/lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local function env_name()
      local vs = package.loaded["venv-selector"]
      local path = vs and vs.venv and vs.venv()
      if path and path ~= "" then
        return vim.fn.fnamemodify(path, ":t")
      end
      if vim.env.CONDA_DEFAULT_ENV and vim.env.CONDA_DEFAULT_ENV ~= "" then
        return vim.env.CONDA_DEFAULT_ENV
      end
      if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
        return vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t")
      end
      return nil
    end

    local python_env = {
      function()
        return "\u{e73c} " .. (env_name() or "no env") -- python logo
      end,
      cond = function()
        return vim.bo.filetype == "python"
      end,
      color = { fg = "#4B8BBE" }, -- python blue
    }

    opts.sections = opts.sections or {}
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    table.insert(opts.sections.lualine_x, 1, python_env)
  end,
}
