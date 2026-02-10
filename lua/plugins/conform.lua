local util = require("conform.util")

-- local function use_oxlint()
--   return vim.fs.find({ "oxlintrc.json", ".oxlintrc.json" }, { upward = true })[1] ~= nil
-- end
-- local jsLinter = use_oxlint() and "oxlint" or "eslint_d"
local jsLinter = "eslint_d"

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
      formatters_by_ft = {
        vue = { jsLinter, "oxfmt" },
        javascript = { jsLinter, "oxfmt" },
        typescript = { jsLinter, "oxfmt" },
        markdown = { "textlint" },
      },
      lsp_fallback = "always",
    },
  },
}
