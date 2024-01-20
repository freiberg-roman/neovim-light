-- local require = require("light.utils.require").require
local core_plugins = {
  { "folke/lazy.nvim",                 tag = "stable" },
  { "tamago324/nlsp-settings.nvim",    cmd = "LspSettings", lazy = false },
  { "jose-elias-alvarez/null-ls.nvim", lazy = false },
  {
    "williamboman/mason.nvim",
    config = function()
      require("light.core.mason").setup()
    end,
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    build = function()
      pcall(function()
        require("mason-registry").refresh()
      end)
    end,
    event = "User FileOpened",
    lazy = true,
  },
  { "nvim-lua/plenary.nvim",                    cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" }, lazy = true },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    config = function()
      require("light.core.telescope").setup()
    end,
    dependencies = { "telescope-fzf-native.nvim" },
    lazy = false,
    cmd = "Telescope",
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make",                                          lazy = true },
  --- {
  ---   "folke/neodev.nvim",
  ---   opts = {},
  ---   lazy = false,
  --- },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    -- run = ":TSUpdate",
    config = function()
      local utils = require "light.utils"
      local path = utils.join_paths(get_runtime_dir(), "site", "pack", "lazy", "opt", "nvim-treesitter")
      vim.opt.rtp:prepend(path) -- treesitter needs to be before nvim's runtime in rtp
      require("light.core.treesitter").setup()
    end,
    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSInstallInfo",
      "TSInstallSync",
      "TSInstallFromGrammar",
    },
    event = "User FileOpened",
  },

  -- NvimTree
  {
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("light.core.nvimtree").setup()
    end,
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
    event = "User DirOpened",
    lazy = false,
  },
  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    enabled = true,
    lazy = true,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.cmd("colorscheme " .. "catppuccin-latte") --- try also mocha
    end,
  },
  { "github/copilot.vim", lazy = false },
}

return core_plugins
