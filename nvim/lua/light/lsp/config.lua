local skipped_servers = {
}

local skipped_filetypes = {"rst", "plaintext", "toml", "proto" }

local join_paths = require("light.utils").join_paths

local M = {}
M.config = {
  templates_dir = join_paths(get_runtime_dir(), "site", "after", "ftplugin"),
  ---@deprecated use vim.diagnostic.config({ ... }) instead
  diagnostics = {},
  document_highlight = false,
  code_lens_refresh = true,
  on_attach_callback = nil,
  on_init_callback = nil,
  automatic_configuration = {
    ---@usage list of servers that the automatic installer will skip
    skipped_servers = skipped_servers,
    ---@usage list of filetypes that the automatic installer will skip
    skipped_filetypes = skipped_filetypes,
  },
  buffer_mappings = {
    normal_mode = {
      ["K"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover" },
      ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition" },
      ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto Declaration" },
      ["gr"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "Goto references" },
      ["gI"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Goto Implementation" },
      ["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "show signature help" },
      ["gl"] = {
        function()
          local float = vim.diagnostic.config().float

          if float then
            local config = type(float) == "table" and float or {}
            config.scope = "line"

            vim.diagnostic.open_float(config)
          end
        end,
        "Show line diagnostics",
      },
    },
    insert_mode = {},
    visual_mode = {},
  },
  buffer_options = {
    --- enable completion triggered by <c-x><c-o>
    omnifunc = "v:lua.vim.lsp.omnifunc",
    --- use gq for formatting
    formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})",
  },
  ---@usage list of settings of nvim-lsp-installer
  installer = {
    setup = {
      ensure_installed = {},
      automatic_installation = {
        exclude = {},
      },
    },
  },
  nlsp_settings = {
    setup = {
      config_home = join_paths(get_light_base_dir(), "lsp-settings"),
      -- set to false to overwrite schemastore.nvim
      append_default_schemas = true,
      ignored_servers = {},
      loader = "json",
    },
  },
  null_ls = {
    setup = {
      debug = false,
    },
    config = {},
  },
  ---@deprecated use light.lsp.automatic_configuration.skipped_servers instead
  override = {},
  ---@deprecated use light.lsp.installer.setup.automatic_installation instead
  automatic_servers_installation = nil,
}

-- Settings for python
local light_icons = require("light.icons")
local default_diagnostic_config = {
  signs = {
    active = true,
    values = {
      { name = "DiagnosticSignError", text = light_icons.diagnostics.Error },
      { name = "DiagnosticSignWarn", text = light_icons.diagnostics.Warning },
      { name = "DiagnosticSignHint", text = light_icons.diagnostics.Hint },
      { name = "DiagnosticSignInfo", text = light_icons.diagnostics.Information },
    },
  },
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}
vim.diagnostic.config(default_diagnostic_config)
local formatter = require("light.lsp.null-ls.formatters")
formatter.setup { { name = "black" }}

return M