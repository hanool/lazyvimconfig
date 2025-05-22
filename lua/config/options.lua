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
