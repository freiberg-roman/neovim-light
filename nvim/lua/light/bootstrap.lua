local M = {}

---Join path segments that were passed as input
---@return string
function _G.join_paths(...)
  local result = table.concat({ ... }, "/")
  return result
end

_G.require_clean = require("light.utils.modules").require_clean
_G.require_safe = require("light.utils.modules").require_safe
_G.reload = require("light.utils.modules").reload

---Get the full path to `$LUNARVIM_RUNTIME_DIR`
---@return string|nil
function _G.get_runtime_dir()
  local light_runtime_dir = os.getenv "LUNARVIM_RUNTIME_DIR"
  if not light_runtime_dir then
    -- when nvim is used directly
    return vim.call("stdpath", "data")
  end
  return light_runtime_dir
end

---Get the full path to `$LUNARVIM_CONFIG_DIR`
---@return string|nil
function _G.get_config_dir()
  local light_config_dir = os.getenv "LUNARVIM_CONFIG_DIR"
  if not light_config_dir then
    return vim.call("stdpath", "config")
  end
  return light_config_dir
end

---Get the full path to `$LUNARVIM_CACHE_DIR`
---@return string|nil
function _G.get_cache_dir()
  local light_cache_dir = os.getenv "LUNARVIM_CACHE_DIR"
  if not light_cache_dir then
    return vim.call("stdpath", "cache")
  end
  return light_cache_dir
end

---Initialize the `&runtimepath` variables and prepare for startup
---@return table
function M:init()
  self.runtime_dir = get_runtime_dir()
  self.config_dir = get_config_dir()
  self.cache_dir = get_cache_dir()
  self.pack_dir = join_paths(self.runtime_dir, "site", "pack")
  self.lazy_install_dir = join_paths(self.pack_dir, "lazy", "opt", "lazy.nvim")
  self.home = os.getenv("HOME")

  ---@meta overridden to use LUNARVIM_CACHE_DIR instead, since a lot of plugins call this function internally
  ---NOTE: changes to "data" are currently unstable, see #2507
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.fn.stdpath = function(what)
    if what == "cache" then
      return _G.get_cache_dir()
    end
    return vim.call("stdpath", what)
  end

  ---Get the full path to LunarVim's base directory
  ---@return string
  function _G.get_light_base_dir()
    return join_paths(self.home, ".config", "nvim")
  end

  if os.getenv "LUNARVIM_RUNTIME_DIR" then
    vim.opt.rtp:remove(join_paths(vim.call("stdpath", "data"), "site"))
    vim.opt.rtp:remove(join_paths(vim.call("stdpath", "data"), "site", "after"))
    -- vim.opt.rtp:prepend(join_paths(self.runtime_dir, "site"))
    vim.opt.rtp:append(join_paths(self.runtime_dir, "light", "after"))
    vim.opt.rtp:append(join_paths(self.runtime_dir, "site", "after"))

    vim.opt.rtp:remove(vim.call("stdpath", "config"))
    vim.opt.rtp:remove(join_paths(vim.call("stdpath", "config"), "after"))
    vim.opt.rtp:prepend(self.config_dir)
    vim.opt.rtp:append(join_paths(self.config_dir, "after"))

    vim.opt.packpath = vim.opt.rtp:get()
  end

  require("light.plugin-loader").init {}

  require("light.config"):init()

  require("light.core.mason").bootstrap()

  return self
end

---Update LunarVim
---pulls the latest changes from github and, resets the startup cache
function M:update()
  require("light.core.log"):info "Trying to update LunarVim..."

  vim.schedule(function()
    reload("light.utils.hooks").run_pre_update()
    local ret = reload("light.utils.git").update_base_light()
    if ret then
      reload("light.utils.hooks").run_post_update()
    end
  end)
end

return M
