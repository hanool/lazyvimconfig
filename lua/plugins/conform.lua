local util = require("conform.util")
local uv = vim.uv or vim.loop

local home = uv.os_homedir()
local oxfmt_command = util.from_node_modules("oxfmt")
local oxlint_command = util.from_node_modules("oxlint")

-- npm's Oxc launchers can spawn a native child process. Running them through
-- `timeout` ensures the whole command group is terminated if Conform or Neovim exits.
local OXC_TIMEOUT_ARGS = { "--signal=TERM", "--kill-after=1s", "3s" }

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

local function with_process_timeout(command, args)
  local timeout_args = vim.deepcopy(OXC_TIMEOUT_ARGS)
  vim.list_extend(timeout_args, { command })
  return vim.list_extend(timeout_args, args)
end

local function command_is_available(resolve_command)
  return function(config, ctx)
    return vim.fn.executable(resolve_command(config, ctx)) == 1
  end
end

local jsLinter = "oxlint"

return {
  {
    "stevearc/conform.nvim",
    opts = {
      log_level = vim.log.levels.DEBUG,
      formatters = {
        -- textlint = {
        --   meta = {
        --     url = "https://github.com/textlint/textlint",
        --     description = "The pluggable linting tool for text and markdown.",
        --   },
        --   command = util.from_node_modules("textlint"),
        --   args = { "--fix", "--format", "fixed-result", "--stdin", "--stdin-filename", "$FILENAME" },
        --   cwd = util.root_file({
        --     ".textlintrc",
        --     ".textlintrc.json",
        --     ".textlintrc.js",
        --     ".textlintrc.cjs",
        --     ".textlintrc.yml",
        --     ".textlintrc.yaml",
        --   }),
        -- },
        oxfmt = {
          command = "timeout",
          condition = command_is_available(oxfmt_command),
          args = function(config, ctx)
            local oxfmt_args = with_optional_config(
              { "--stdin-filepath", "$FILENAME" },
              find_oxc_config(ctx, OXFMT_PROJECT_CONFIGS, OXFMT_GLOBAL_CONFIGS)
            )
            return with_process_timeout(oxfmt_command(config, ctx), oxfmt_args)
          end,
        },
        oxlint = {
          command = "timeout",
          condition = command_is_available(oxlint_command),
          args = function(config, ctx)
            local oxlint_args = with_optional_config(
              { "--fix", "$FILENAME" },
              find_oxc_config(ctx, OXLINT_PROJECT_CONFIGS, OXLINT_GLOBAL_CONFIGS)
            )
            return with_process_timeout(oxlint_command(config, ctx), oxlint_args)
          end,
        },
      },
      formatters_by_ft = {
        vue = { jsLinter, "oxfmt" },
        javascript = { jsLinter, "oxfmt" },
        typescript = { jsLinter, "oxfmt" },
        -- markdown = { "textlint" },
      },
      lsp_fallback = "always",
    },
  },
}
