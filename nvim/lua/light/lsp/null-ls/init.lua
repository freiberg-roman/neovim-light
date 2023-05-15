local M = {}

function M.setup()
  local _, null_ls = pcall(require, "null-ls")
  local default_opts = require("light.lsp").get_common_opts()
  null_ls.setup(vim.tbl_deep_extend("force", default_opts, light.lsp.null_ls.setup))
end

return M
