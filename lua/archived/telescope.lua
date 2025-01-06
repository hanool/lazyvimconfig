return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
    },
  },
  opts = function(_, opts)
    local lga_actions = require("telescope-live-grep-args.actions")
    opts.extensions = {
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        -- define mappings, e.g.
        mappings = { -- extend mappings
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          },
        },
        -- ... also accepts theme settings, for example:
        -- theme = "dropdown", -- use dropdown theme
        -- theme = { }, -- use own theme spec
        -- layout_config = { mirror=true }, -- mirror preview pane
      },
    }
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      mappings = {
        i = {
          ["<C-j>"] = require("telescope.actions").move_selection_next,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
        },
        n = { -- while in normal mode
          ["<C-j>"] = require("telescope.actions").move_selection_next,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
        },
      },
    })
  end,
  keys = {
    {
      "<leader>/",
      "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
      desc = "Grep (root dir)",
    },
  },
  config = function(_, opts)
    local tele = require("telescope")
    tele.setup(opts)
    tele.load_extension("live_grep_args")
  end,
}
