-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Show the app's output when xcodebuild.nvim launches it. A debug launch gets the
-- dap-ui console instead (plugins/xcodebuild.lua closes this window when it opens).
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("xcode_app_logs", { clear = true }),
  pattern = "XcodebuildApplicationLaunched",
  callback = function()
    vim.schedule(function()
      local dap = package.loaded["dap"]
      if not (dap and dap.session()) then
        require("xcode_app_logs").open()
      end
    end)
  end,
})
