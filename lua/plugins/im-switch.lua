return {
  "drop-stones/im-switch.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    mode = "restore",
    wsl2 = {
      server = true,
    },
  },
}
