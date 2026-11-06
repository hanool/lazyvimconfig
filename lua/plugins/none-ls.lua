return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls")
    -- opts.root_dir = opts.root_dir
    --   or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
    opts.sources = vim.list_extend(opts.sources or {}, {
      nls.builtins.diagnostics.textlint.with({
        filetypes = { "markdown" },
        condition = function(utils)
          return utils.root_has_file({
            ".textlintrc",
            ".textlintrc.json",
            ".textlintrc.js",
            ".textlintrc.cjs",
            ".textlintrc.yml",
            ".textlintrc.yaml",
          })
        end,
      }),
      -- nls.builtins.formatting.fish_indent,
      -- nls.builtins.diagnostics.fish,
      -- nls.builtins.formatting.stylua,
      -- nls.builtins.formatting.shfmt,
    })
  end,
}
