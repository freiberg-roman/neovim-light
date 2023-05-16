-- local require = require("light.utils.require").require
local core_plugins = {
  { "folke/lazy.nvim", tag = "stable" },
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = { "mason-lspconfig.nvim", "nlsp-settings.nvim" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    config = function()
      local lsp = require("light.lsp.config")
      require("mason-lspconfig").setup(lsp.config.installer.setup)

      -- automatic_installation is handled by lsp-manager
      local settings = require "mason-lspconfig.settings"
      settings.current.automatic_installation = false
    end,
    lazy = true,
    event = "User FileOpened",
    dependencies = "mason.nvim",
  },
  { "tamago324/nlsp-settings.nvim", cmd = "LspSettings", lazy = true },
  { "jose-elias-alvarez/null-ls.nvim", lazy = true },
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
  { "nvim-lua/plenary.nvim", cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" }, lazy = true },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    config = function()
      require("light.core.telescope").setup()
    end,
    dependencies = { "telescope-fzf-native.nvim" },
    lazy = true,
    cmd = "Telescope",
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
  -- Install nvim-cmp, and buffer source as a dependency
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("light.core.cmp").setup()
    end,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "cmp-nvim-lsp",
      "cmp-buffer",
      "cmp-path",
      "cmp-cmdline",
    },
  },
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  { "hrsh7th/cmp-buffer", lazy = true },
  { "hrsh7th/cmp-path", lazy = true },
  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
    enabled = true,
  },
  {
    "folke/neodev.nvim",
    lazy = true,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("light.core.autopairs").setup()
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
  },

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
  },
  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    enabled = true,
    lazy = true,
  },

  {
    "akinsho/bufferline.nvim",
    config = function()
      require("light.core.bufferline").setup()
    end,
    branch = "main",
    event = "User FileOpened",
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("light.core.dap").setup()
    end,
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
  },

  -- Debugger user interface
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("light.core.dap").setup_ui()
    end,
    lazy = true,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    branch = "main",
    init = function()
      require("light.core.terminal").init()
    end,
    config = function()
      require("light.core.terminal").setup()
    end,
    cmd = {
      "ToggleTerm",
      "TermExec",
      "ToggleTermToggleAll",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
    },
    lazy = false,
  },

  -- Theme
  { "catppuccin/nvim", name = "catppuccin",
    config = function()
      vim.cmd("colorscheme " .. "catppuccin-latte")
    end,
  },
}

return core_plugins
