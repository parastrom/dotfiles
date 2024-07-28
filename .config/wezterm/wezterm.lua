local wezterm = require 'wezterm'
local config = wezterm.config_builder()


config.default_prog = { '/bin/zsh' }

-- Import other modules
local keys = require 'keys'
local appearance = require 'appearance'
local smart_splits = require 'smart_splits'

-- Apply configurations from modules
keys.apply_to_config(config)
appearance.apply_to_config(config)
smart_splits.apply_to_config(config)

-- Any additional configuration can go here

return config
