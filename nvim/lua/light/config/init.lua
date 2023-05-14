local utils = require "light.utils"

local M = {}

--- Initialize light default configuration and variables
function M:init()
  light = vim.deepcopy(require "light.config.light")

  require("light.keymappings").load_defaults()
  local settings = require "light.config.settings"
  settings.load_defaults()

  local autocmds = require "light.core.autocmds"
  autocmds.load_defaults()

  local light_lsp_config = require "light.lsp.config"
  light.lsp = vim.deepcopy(light_lsp_config)
end
return M