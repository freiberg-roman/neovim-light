local M = {}

local in_headless = #vim.api.nvim_list_uis() == 0
local plugin_loader = require "light.plugin-loader"

---Reset any startup cache files used by lazy.nvim
---It also forces regenerating any template ftplugin files
---Tip: Useful for clearing any outdated settings
function M.reset_cache()
  local light_modules = {}
  for module, _ in pairs(package.loaded) do
    if module:match "light.core" or module:match "light.lsp" then
      package.loaded[module] = nil
      table.insert(light_modules, module)
    end
  end
  require("light.lsp.templates").generate_templates()
end

function M.run_post_update()

  if vim.fn.has "nvim-0.8" ~= 1 then
    local compat_tag = "1.1.4"
    vim.notify(
      "Please upgrade your Neovim base installation. Newer version of Lunarvim requires v0.7+",
      vim.log.levels.WARN
    )
    vim.wait(1000)
    local ret = reload("light.utils.git").switch_light_branch(compat_tag)
    if ret then
      vim.notify("Reverted to the last known compatible version: " .. compat_tag, vim.log.levels.WARN)
    end
    return
  end

  M.reset_cache()

  plugin_loader.reload { reload "light.plugins", light.plugins }
  plugin_loader.sync_core_plugins()
  M.reset_cache() -- force cache clear and templates regen once more

  if not in_headless then
    vim.schedule(function()
      if package.loaded["nvim-treesitter"] then
        vim.cmd [[ TSUpdateSync ]]
      end
      -- TODO: add a changelog
      vim.notify("Update complete", vim.log.levels.INFO)
    end)
  end
end

return M
