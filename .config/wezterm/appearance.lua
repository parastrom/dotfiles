local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
	config.window_decorations = "NONE"
	config.font = wezterm.font("JetBrainsMono Nerd Font")
	config.font_size = 9.0
	config.window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	}
	config.color_scheme = "Neutron (Gogh)"

	config.tab_bar_at_bottom = false
	config.use_fancy_tab_bar = false -- Changed to false for more control
	config.window_frame = {
		font_size = 9.0,
	}
end

return M
