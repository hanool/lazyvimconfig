return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      component_separators = "",
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
      lualine_z = {
        {
          function()
            return vim.uv.os_uname().sysname .. " | " .. vim.uv.os_uname().machine
          end,
          separator = { right = "" },
          left_padding = 2,
        },
      },
    },
  },
}
