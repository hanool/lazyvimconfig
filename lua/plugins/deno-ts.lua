return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      denols = function(_, opts)
        opts.root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc")
      end,
      ts_ls = function(_, opts)
        opts.root_dir = require("lspconfig").util.root_pattern("package.json")
        opts.single_file_support = false
      end,
    },
  },
}
