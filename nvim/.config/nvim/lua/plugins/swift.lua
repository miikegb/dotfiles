-- macOS beta workaround: the host is on a prerelease macOS whose only matching
-- SDK (CommandLineTools' MacOSX27.0.sdk) is malformed, so `xcrun --show-sdk-path`
-- — clang's default sysroot — fails at link time. That breaks native compiles
-- like tree-sitter parsers. Point native builds at Xcode's valid macOS SDK.
-- Scoped to Neovim's env only, so terminal `xcodebuild` (iOS) is untouched;
-- sourcekit-lsp still uses the explicit iOS `-sdk` flags from buildServer.json.
if vim.fn.has("mac") == 1 and (vim.env.SDKROOT == nil or vim.env.SDKROOT == "") then
  local dev = vim.trim(vim.fn.system({ "xcode-select", "-p" }))
  local sdk = dev .. "/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
  if vim.v.shell_error == 0 and vim.uv.fs_stat(sdk) then
    vim.env.SDKROOT = sdk
  end
end

return {
  -- Swift syntax/highlighting/textobjects
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "swift" } },
  },

  -- sourcekit-lsp: the Swift/ObjC language server that ships with Xcode.
  -- It is NOT a mason package, so we point cmd at the Xcode toolchain via xcrun.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          -- xcrun resolves to the active Xcode's toolchain (see `xcode-select -p`)
          cmd = { "xcrun", "sourcekit-lsp" },
          -- Look upward for these markers so the root is the repo, not a package.
          root_markers = {
            "buildServer.json",
            "Package.swift",
            "*.xcodeproj",
            "*.xcworkspace",
            ".git",
          },
          filetypes = { "swift", "objc", "objcpp", "c", "cpp" },
          capabilities = {
            workspace = {
              -- sourcekit needs dynamic file-watching to notice new/edited files
              -- across the workspace, otherwise cross-module symbols go stale.
              didChangeWatchedFiles = { dynamicRegistration = true },
            },
          },
        },
      },
    },
  },
}
