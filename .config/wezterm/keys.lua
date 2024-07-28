local wezterm = require 'wezterm'

local M = {}

function M.apply_to_config(config)
  config.leader = { key = "a", mods = "CTRL" }
  config.keys = {
    { key = "a", mods = "LEADER|CTRL",  action = wezterm.action { SendString = "\x01" } },
    { key = "-", mods = "LEADER",       action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
    { key = "t", mods = "CTRL",         action = wezterm.action { SendString = "Test" } },
    { key = "p", mods = "LEADER",       action = wezterm.action { ActivateTabRelative = -1 } },
    { key = "n", mods = "LEADER",       action = wezterm.action { ActivateTabRelative = 1 } },
    { key = "o", mods = "LEADER",       action = "TogglePaneZoomState" },
    { key = "z", mods = "LEADER",       action = "TogglePaneZoomState" },
    { key = "c", mods = "LEADER",       action = wezterm.action { SpawnTab = "CurrentPaneDomain" } },
    { key = "H", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Left", 5 } } },
    { key = "J", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Down", 5 } } },
    { key = "K", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Up", 5 } } },
    { key = "L", mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Right", 5 } } },
    -- { key = "1", mods = "LEADER",       action = wezterm.action { ActivateTab = 0 } },
    -- { key = "2", mods = "LEADER",       action = wezterm.action { ActivateTab = 1 } },
    -- { key = "3", mods = "LEADER",       action = wezterm.action { ActivateTab = 2 } },
    -- { key = "4", mods = "LEADER",       action = wezterm.action { ActivateTab = 3 } },
    -- { key = "5", mods = "LEADER",       action = wezterm.action { ActivateTab = 5 } },
    -- { key = "6", mods = "LEADER",       action = wezterm.action { ActivateTab = 5 } },
    -- { key = "7", mods = "LEADER",       action = wezterm.action { ActivateTab = 6 } },
    -- { key = "8", mods = "LEADER",       action = wezterm.action { ActivateTab = 7 } },
    -- { key = "9", mods = "LEADER",       action = wezterm.action { ActivateTab = 8 } },
    { key = "y", mods = "LEADER",       action = wezterm.action { CloseCurrentTab = { confirm = true } } },
    { key = "x", mods = "LEADER",       action = wezterm.action { CloseCurrentPane = { confirm = true } } }, { key = "|", mods = "LEADER|SHIFT", action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
  }
end

return M
