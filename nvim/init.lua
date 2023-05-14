require("light.bootstrap"):init()

local plugins = require "light.plugins"
require("light.plugin-loader").load { plugins, light.plugins }