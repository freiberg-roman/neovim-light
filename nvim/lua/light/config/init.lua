local utils = require "light.utils"

local M = {}
local user_config_dir = get_config_dir()
local user_config_file = utils.join_paths(user_config_dir, "config.lua")

---Get the full path to the user configuration file
---@return string
function M:get_user_config_path()
  return user_config_file
end

--- Initialize light default configuration and variables
function M:init()
  light = vim.deepcopy(require "light.config.defaults")

  require("light.keymappings").load_defaults()
  local settings = require "light.config.settings"
  settings.load_defaults()

  local autocmds = require "light.core.autocmds"
  autocmds.load_defaults()

  local light_lsp_config = require "light.lsp.config"
  light.lsp = vim.deepcopy(light_lsp_config)
end
return M