return {
  leader = "space",
  colorscheme = "lunar",
  format_on_save = {
    ---@usage boolean: format on save (Default: false)
    enabled = false,
    ---@usage pattern string pattern used for the autocommand (Default: '*')
    pattern = "*",
    ---@usage timeout number timeout in ms for the format request (Default: 1000)
    timeout = 1000,
    ---@usage filter func to select client
    filter = require("light.lsp.utils").format_filter,
  },
  keys = {},

  use_icons = true,
  icons = require "light.icons",

  builtin = {},

  plugins = {
    -- use config.lua for this not put here
  },

  lazy = {
    opts = {
      install = {
        missing = true,
        colorscheme = { "lunar", "habamax" },
      },
      ui = {
        border = "rounded",
      },
      root = require("light.utils").join_paths(get_runtime_dir(), "site", "pack", "lazy", "opt"),
      performance = {
        rtp = {
          reset = false,
        },
      },
      defaults = {
        lazy = false,
        version = nil,
      },
      readme = {
        root = require("light.utils").join_paths(get_runtime_dir(), "lazy", "readme"),
      },
    },
  },

  autocommands = {},
  lang = {},
  log = {
    ---@usage can be { "trace", "debug", "info", "warn", "error", "fatal" },
    level = "info",
    viewer = {
      ---@usage this will fallback on "less +F" if not found
      cmd = "lnav",
      layout_config = {
        ---@usage direction = 'vertical' | 'horizontal' | 'window' | 'float',
        direction = "float",
        open_mapping = "",
        size = 40,
        float_opts = {},
      },
    },
    -- currently disabled due to instabilities
    override_notify = false,
  },
}
