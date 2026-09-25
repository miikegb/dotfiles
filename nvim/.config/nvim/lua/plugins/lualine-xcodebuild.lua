-- Show the active xcodebuild scheme + device AND the live build/test status in lualine.
-- xcodebuild.nvim keeps these globals current:
--   vim.g.xcodebuild_scheme / _device_name / _os / _platform / _test_plan / _last_status
-- Glyphs are \u{...} escapes so the source stays plain ASCII.
return {
  "nvim-lualine/lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local function has(v)
      return v ~= nil and v ~= ""
    end

    -- Scheme + device
    local target = {
      function()
        local parts = {}
        if has(vim.g.xcodebuild_scheme) then
          table.insert(parts, "\u{f0ad} " .. vim.g.xcodebuild_scheme) -- wrench
        end
        if has(vim.g.xcodebuild_device_name) then
          local device = "\u{f10b} " .. vim.g.xcodebuild_device_name -- mobile
          if has(vim.g.xcodebuild_os) then
            device = device .. " (" .. vim.g.xcodebuild_os .. ")"
          end
          table.insert(parts, device)
        end
        return table.concat(parts, "  ")
      end,
      cond = function()
        return has(vim.g.xcodebuild_scheme) or has(vim.g.xcodebuild_device_name)
      end,
      color = { fg = "#CE9F09" }, -- Slips brand gold
    }

    -- Live build/test status, colored + icon'd by state.
    local function status_icon(s)
      if s:find("Fail") then
        return "\u{f00d}" -- x
      elseif s:find("Succeeded") or s:find("Passed") then
        return "\u{f00c}" -- check
      elseif s:find("Cancelled") then
        return "\u{f05e}" -- ban
      elseif s:find("%.%.%.") then
        return "\u{f085}" -- cogs (in progress)
      end
      return "\u{f085}"
    end

    local status = {
      function()
        return status_icon(vim.g.xcodebuild_last_status) .. " " .. vim.g.xcodebuild_last_status
      end,
      cond = function()
        return has(vim.g.xcodebuild_last_status)
      end,
      color = function()
        local s = vim.g.xcodebuild_last_status or ""
        if s:find("Fail") then
          return { fg = "#f7768e" } -- red
        elseif s:find("Succeeded") or s:find("Passed") then
          return { fg = "#9ece6a" } -- green
        elseif s:find("Cancelled") then
          return { fg = "#a9b1d6" } -- gray
        elseif s:find("%.%.%.") then
          return { fg = "#e0af68" } -- amber (in progress)
        end
        return { fg = "#a9b1d6" }
      end,
    }

    opts.sections = opts.sections or {}
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    -- Insert at the front of lualine_x: [status, target, ...existing]
    table.insert(opts.sections.lualine_x, 1, target)
    table.insert(opts.sections.lualine_x, 1, status)

    -- Refresh lualine on xcodebuild status changes (instead of waiting for the ~1s
    -- statusline timer). Deferred with vim.schedule because xcodebuild fires these
    -- events BEFORE updating vim.g.xcodebuild_last_status; refreshing synchronously
    -- would read the previous value (e.g. leaving "Running Tests..." stuck after a
    -- run finishes). Scheduling runs the refresh after the variable settles.
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("xcodebuild_lualine", { clear = true }),
      pattern = "Xcodebuild*",
      callback = function()
        vim.schedule(function()
          pcall(function()
            require("lualine").refresh()
          end)
        end)
      end,
    })
  end,
}
