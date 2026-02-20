local util = require("conform.util")
local uv = vim.uv or vim.loop

local home = uv.os_homedir()

local OXFMT_PROJECT_CONFIGS = {
  ".oxfmtrc.json",
  ".oxfmtrc.jsonc",
}

local OXFMT_GLOBAL_CONFIGS = {
  home .. "/.oxfmtrc.json",
  home .. "/.oxfmtrc.jsonc",
  home .. "/.config/oxc/.oxfmtrc.json",
  home .. "/.config/oxc/.oxfmtrc.jsonc",
}

local OXLINT_PROJECT_CONFIGS = {
  "oxlintrc.json",
  ".oxlintrc.json",
  ".oxlintrc.jsonc",
}

local OXLINT_GLOBAL_CONFIGS = {
  home .. "/oxlintrc.json",
  home .. "/.oxlintrc.json",
  home .. "/.oxlintrc.jsonc",
  home .. "/.config/oxc/oxlintrc.json",
  home .. "/.config/oxc/.oxlintrc.json",
  home .. "/.config/oxc/.oxlintrc.jsonc",
}

local function first_existing_path(paths)
  for _, path in ipairs(paths) do
    if uv.fs_stat(path) then
      return path
    end
  end
end

local function find_oxc_config(ctx, project_files, global_files)
  local project_config = vim.fs.find(project_files, {
    upward = true,
    path = ctx.dirname,
    limit = 1,
  })[1]

  if project_config then
    return project_config
  end

  return first_existing_path(global_files)
end

local function with_optional_config(args, config)
  if not config then
    return args
  end

  return vim.list_extend({ "--config", config }, args)
end

local jsLinter = "oxlint"

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
        oxfmt = {
          args = function(_, ctx)
            local config = find_oxc_config(ctx, OXFMT_PROJECT_CONFIGS, OXFMT_GLOBAL_CONFIGS)
            return with_optional_config({ "--stdin-filepath", "$FILENAME" }, config)
          end,
        },
        oxlint = {
          args = function(_, ctx)
            local config = find_oxc_config(ctx, OXLINT_PROJECT_CONFIGS, OXLINT_GLOBAL_CONFIGS)
            return with_optional_config({ "--fix", "$FILENAME" }, config)
          end,
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
