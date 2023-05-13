local M = {}

local builtins = {
  "light.core.theme",
  "light.core.cmp",
  "light.core.dap",
  "light.core.terminal",
  "light.core.telescope",
  "light.core.treesitter",
  "light.core.nvimtree",
  "light.core.lir",
  "light.core.breadcrumbs",
  "light.core.bufferline",
  "light.core.autopairs",
  "light.core.mason",
}

function M.config(config)
  for _, builtin_path in ipairs(builtins) do
    local builtin = reload(builtin_path)

    builtin.config(config)
  end
end

return M
