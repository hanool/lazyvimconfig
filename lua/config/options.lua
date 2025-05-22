-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"

vim.opt.hidden = false

-- Some OS detectors
local is_wsl = vim.fn.has("wsl") == 1
-- local is_mac = vim.fn.has("macunix") == 1
-- local is_linux = not is_wsl and not is_mac

-- WSL Clipboard support
if is_wsl then
  -- This is NeoVim's recommended way to solve clipboard sharing if you use WSL
  -- See: https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "pwsh.exe -NoLogo -NoProfile -c chcp 65001 | Out-Null; clip.exe",
      ["*"] = "pwsh.exe -NoLogo -NoProfile -c chcp 65001 | Out-Null; clip.exe",
    },
    paste = {
      ["+"] = 'pwsh.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'pwsh.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

local function upgrade_vue()
  local filepath = vim.fn.expand("%:p")
  local cmd = { "npx", "vue-upgrade-tool", "--files", filepath }

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        vim.cmd("checktime")
        if code == 0 then
          vim.notify("upgrade vue successfully", vim.log.levels.INFO)
        else
          vim.notify("upgrade vue failed (exit code " .. code .. ")", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end

local function transform_vue()
  local filepath = vim.fn.expand("%:p")
  local cmd = { "npx", "scriptshifter", "--files", filepath, "--vue", "2.7" }

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        vim.cmd("checktime")
        if code == 0 then
          vim.notify("converted options api to composition api successfully", vim.log.levels.INFO)
          upgrade_vue()
        else
          vim.notify(
            "converting options api to composition api failed (exit code " .. code .. ")",
            vim.log.levels.ERROR
          )
        end
      end)
    end,
  })
end

vim.keymap.set("n", "<leader>vx", transform_vue, { noremap = true, silent = true })
