local M = {}

-- defaults are user configs in this case -> will restructure later
function M:init()
  require("light.keymappings").load_defaults()
  local settings = require "light.config.settings"
  settings.load_defaults()
end

return M

