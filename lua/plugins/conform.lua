local util = require("conform.util")

return {
  {
    "stevearc/conform.nvim",
    opts = {
      log_level = vim.log.levels.DEBUG,
      formatters = {
        textlint = {
          meta = {
            url = "https://github.com/textlint/textlint",
            description = "The pluggable linting tool for text and markdown.",
          },
          command = util.from_node_modules("textlint"),
          args = { "--stdin", "--stdin-filename", "$FILENAME" },
          cwd = util.root_file({
            "package.json",
          }),
        },
      },
      -- formatters = {
      --   eslint_d = {
      --     env = {
      --       ESLINT_USE_FLAT_CONFIG = true,
      --     },
      --   },
      -- },
      formatters_by_ft = {
        vue = { "eslint_d", "prettierd" },
        javascript = { "eslint_d", "prettierd" },
        typescript = { "eslint_d", "prettierd" },
        markdown = { "textlint" },
      },
      lsp_fallback = "always",
    },
  },
}
