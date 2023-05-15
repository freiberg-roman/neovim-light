local M = {}

function M.setup()
  local _, null_ls = pcall(require, "null-ls")
  local default_opts = require("light.lsp").get_common_opts()
  local lsp = require("light.lsp.config")
  null_ls.setup(vim.tbl_deep_extend("force", default_opts, lsp.config.null_ls.setup))
end

return M
