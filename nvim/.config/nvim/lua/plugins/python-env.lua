-- Make pyright always use the selected Python env (conda / venv).
--
-- venv-selector applies the cached env ~1s after a Python buffer opens and only
-- changes nvim's PATH; if pyright starts before that, it stays on conda base and
-- reports "Import ... could not be resolved". So:
--   1. before pyright starts, resolve the env ourselves and pass it as pythonPath
--   2. whenever an env is (re)activated, push the new pythonPath to running clients

local function cached_python(bufnr)
  local ok_root, pr = pcall(require, "venv-selector.project_root")
  if not ok_root then
    return nil
  end
  local root = pr.key_for_buf(bufnr)
  local file = vim.fn.expand("~/.cache/venv-selector/venvs2.json")
  if not root or vim.fn.filereadable(file) ~= 1 then
    return nil
  end
  local ok, cache = pcall(vim.json.decode, table.concat(vim.fn.readfile(file), "\n"))
  local entry = ok and type(cache) == "table" and cache[root] or nil
  local py = entry and entry.value
  if type(py) == "string" and vim.fn.executable(py) == 1 then
    return py
  end
end

local function resolve_python(bufnr)
  local vs = package.loaded["venv-selector"]
  local py = vs and vs.python and vs.python()
  if py and py ~= "" then
    return py
  end
  py = cached_python(bufnr or vim.api.nvim_get_current_buf())
  if py then
    return py
  end
  if vim.env.CONDA_PREFIX and vim.env.CONDA_PREFIX ~= "" then
    return vim.env.CONDA_PREFIX .. "/bin/python"
  end
end

local function push_python_to_clients(py)
  for _, client in ipairs(vim.lsp.get_clients({ name = "pyright" })) do
    client.settings = client.settings or {}
    client.settings.python = client.settings.python or {}
    client.settings.python.pythonPath = py
    client:notify("workspace/didChangeConfiguration", { settings = client.settings })
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            local py = resolve_python()
            if py then
              -- mutate in place: the client already holds a reference to this table
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = py
            end
          end,
        },
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    optional = true,
    opts = {
      options = {
        on_venv_activate_callback = function()
          local py = resolve_python()
          if py then
            push_python_to_clients(py)
          end
        end,
      },
    },
  },
}
