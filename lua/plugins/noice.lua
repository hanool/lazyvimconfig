return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        hover = {
          enabled = true,
          silent = true, -- set to true to not show a message if hover is not available
          view = nil, -- when nil, use defaults from documentation
        },
      },
    },
  },
}
