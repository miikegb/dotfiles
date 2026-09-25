-- iOS/macOS dev: build, test, run, debug under <leader>x (xcodebuild.nvim).
-- The <leader>x action maps live in lua/config/keymaps.lua (loaded last, so they
-- win over LazyVim's default <leader>x group). Here we install the plugin and
-- move LazyVim's Trouble/quickfix maps off <leader>x onto <leader>d.
return {
  {
    "wojciech-kulik/xcodebuild.nvim",
    -- Load when editing Apple sources or when any Xcodebuild command is used.
    ft = { "swift", "objc", "objcpp" },
    cmd = {
      "XcodebuildPicker",
      "XcodebuildBuild",
      "XcodebuildCleanBuild",
      "XcodebuildBuildForTesting",
      "XcodebuildBuildRun",
      "XcodebuildRun",
      "XcodebuildCancel",
      "XcodebuildTest",
      "XcodebuildTestClass",
      "XcodebuildTestSelected",
      "XcodebuildTestExplorerToggle",
      "XcodebuildFailingSnapshots",
      "XcodebuildToggleLogs",
      "XcodebuildToggleCodeCoverage",
      "XcodebuildShowCodeCoverageReport",
      "XcodebuildSelectDevice",
      "XcodebuildSelectScheme",
      "XcodebuildSelectTestPlan",
      "XcodebuildCodeActions",
      "XcodebuildBuildServer",
      "XcodebuildBootSimulator",
      "XcodebuildProjectManager",
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim", -- picker + view previews (already in LazyVim)
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("xcodebuild").setup({
        show_build_progress_bar = true,
        code_coverage = { enabled = true },
        logs = {
          auto_open_on_failed_tests = true, -- show logs when a test fails
          auto_open_on_success_tests = false, -- keep quiet when tests pass
          auto_focus = false, -- don't steal the cursor while you keep editing
        },
      })
    end,
  },

  -- Relocate LazyVim's Trouble maps: <leader>x* -> <leader>d*
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xx", false },
      { "<leader>xX", false },
      { "<leader>xL", false },
      { "<leader>xQ", false },
      { "<leader>dx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>dX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>dL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>dQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },

  -- ...and the todo-comments Trouble maps
  {
    "folke/todo-comments.nvim",
    keys = {
      { "<leader>xt", false },
      { "<leader>xT", false },
      { "<leader>dt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>dT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    },
  },

  -- which-key group labels
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>x", group = "xcode" },
        { "<leader>d", group = "diagnostics/quickfix" },
      },
    },
  },

  -- Debugging via nvim-dap. Xcode 16+ uses the built-in debug adapter (no codelldb).
  -- Loads on Apple sources; the debug keymaps live in lua/config/keymaps.lua so
  -- they render in the which-key <leader>x menu like the rest.
  {
    "mfussenegger/nvim-dap",
    ft = { "swift", "objc", "objcpp" },
    dependencies = {
      "wojciech-kulik/xcodebuild.nvim",
      { "rcarriga/nvim-dap-ui", dependencies = "nvim-neotest/nvim-nio" }, -- the panels
      "theHamsta/nvim-dap-virtual-text", -- inline variable values
    },
    config = function()
      require("xcodebuild.integrations.dap").setup()

      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- Gutter icons (replaces the default "B"). Needs a Nerd Font.
      -- Glyphs written as \u{...} escapes so the source stays plain ASCII.
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      local signs = {
        Breakpoint = { "\u{f111}", "DiagnosticError" }, -- filled circle
        BreakpointCondition = { "\u{f192}", "DiagnosticError" }, -- dot in circle
        BreakpointRejected = { "\u{f00d}", "DiagnosticError" }, -- x mark
        LogPoint = { "\u{f054}", "DiagnosticInfo" }, -- chevron
        Stopped = { "\u{f061}", "DiagnosticWarn", "DapStoppedLine" }, -- arrow
      }
      for name, sign in pairs(signs) do
        vim.fn.sign_define("Dap" .. name, {
          text = sign[1],
          texthl = sign[2] or "DiagnosticInfo",
          linehl = sign[3],
          numhl = sign[3],
        })
      end

      -- Open the UI when a session starts; close it when it ends.
      dap.listeners.after.event_initialized.dapui = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui = function() dapui.close() end
      dap.listeners.before.event_exited.dapui = function() dapui.close() end
    end,
  },
}
