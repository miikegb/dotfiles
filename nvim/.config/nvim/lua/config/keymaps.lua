-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- <leader>x now belongs to Xcode, so move LazyVim's native quickfix/loclist
-- toggles to <leader>d (alongside the Trouble maps relocated in plugins/xcodebuild.lua).
map("n", "<leader>dl", function()
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd.lclose()
  else
    vim.cmd.lopen()
  end
end, { desc = "Location List" })
map("n", "<leader>dq", function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end, { desc = "Quickfix List" })

-- Xcode: build · test · run (debug maps live in plugins/xcodebuild.lua)
map("n", "<leader>xf", "<cmd>XcodebuildPicker<cr>", { desc = "Show All Actions" })
map("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
map("n", "<leader>xB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" })
map("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run" })
map("n", "<leader>x<cr>", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run" })
map("n", "<leader>xR", "<cmd>XcodebuildRun<cr>", { desc = "Run (no build)" })
map({ "n", "v" }, "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
map("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })
map({ "n", "v" }, "<leader>x.", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" })
map("n", "<leader>xn", "<cmd>XcodebuildTestNearest<cr>", { desc = "Run Nearest Test" })
map("n", "<leader>xF", "<cmd>XcodebuildTestFailing<cr>", { desc = "Re-run Failing Tests" })
map("n", "<leader>x,", "<cmd>XcodebuildTestRepeat<cr>", { desc = "Repeat Last Test Run" })
map("n", "<leader>xe", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" })
map("n", "<leader>xs", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" })
map("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Logs" })
map("n", "<leader>xL", function() require("xcode_app_logs").toggle() end, { desc = "Toggle App Logs" })
map("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" })
map("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", { desc = "Code Coverage Report" })
map("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
map("n", "<leader>xX", "<cmd>XcodebuildSelectScheme<cr>", { desc = "Select Scheme" })
-- Switch the main project/workspace (handy with Tuist-generated workspaces),
-- then re-pick the scheme since schemes differ per project.
map("n", "<leader>xw", function()
  require("lazy").load({ plugins = { "xcodebuild.nvim" } })
  local pickers = require("xcodebuild.ui.pickers")
  pickers.select_project(function()
    pickers.select_scheme()
  end)
end, { desc = "Select Project / Workspace" })
map("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
map("n", "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Code Actions" })
map("n", "<leader>xo", "<cmd>XcodebuildProjectManager<cr>", { desc = "Project Manager" })
map("n", "<leader>x0", "<cmd>XcodebuildBootSimulator<cr>", { desc = "Boot Simulator" })
map("n", "<leader>x-", "<cmd>XcodebuildCancel<cr>", { desc = "Cancel Running Action" })
-- Regenerate buildServer.json so sourcekit-lsp picks up new files/flags
map("n", "<leader>xg", "<cmd>XcodebuildBuildServer<cr>", { desc = "Regenerate Build Server (LSP)" })

-- Xcode: debug (nvim-dap loads on Swift files, see plugins/xcodebuild.lua)
local function xcdap(fn)
  return function()
    require("xcodebuild.integrations.dap")[fn]()
  end
end
map("n", "<leader>xD", xcdap("build_and_debug"), { desc = "Build & Debug" })
map("n", "<leader>x;", xcdap("debug_without_build"), { desc = "Debug (no build)" })
map("n", "<leader>xS", xcdap("terminate_session"), { desc = "Stop Debugger" })
map("n", "<leader>xk", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
map("n", "<leader>xK", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Conditional Breakpoint" })
map("n", "<leader>xu", function() require("dapui").toggle() end, { desc = "Toggle Debugger UI" })
map({ "n", "v" }, "<leader>xE", function() require("dapui").eval() end, { desc = "Evaluate Expression" })
map("n", "<leader>xj", function() require("dap").run_to_cursor() end, { desc = "Run to Cursor" })
map("n", "<leader>x'", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
map("n", "<F5>", function() require("dap").continue() end, { desc = "Debug: Continue" })
map("n", "<F10>", function() require("dap").step_over() end, { desc = "Debug: Step Over" })
map("n", "<F11>", function() require("dap").step_into() end, { desc = "Debug: Step Into" })
map("n", "<F12>", function() require("dap").step_out() end, { desc = "Debug: Step Out" })
