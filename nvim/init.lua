require("light.bootstrap"):init()
require("light.config"):load()

local plugins = require "light.plugins"
require("light.plugin-loader").load { plugins, light.plugins }
require("light.core.theme").setup()

local Log = require "light.core.log"
local commands = require "light.core.commands"
commands.load(commands.defaults)
