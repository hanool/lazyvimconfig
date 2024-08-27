return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      volar = function(_, opts)
        -- opts.filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
        opts.init_options = {
          vue = {
            hybridMode = false,
          },
        }
      end,
      tsserver = function(_, opts)
        local mason_registry = require("mason-registry")
        local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
          .. "/node_modules/@vue/language-server"

        opts.init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_language_server_path,
              languages = { "vue" },
            },
          },
        }

        -- opts.filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
      end,
    },
  },
}
