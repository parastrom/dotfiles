return {
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
		opts = function()
			return {
				-- This callback can be used to override the colors used in the base palette.
				on_palette = function(palette) end,
				-- This callback can be used to override the colors used in the extended palette.
				after_palette = function(palette) end,
				-- This callback can be used to override highlights before they are applied.
				-- Enable bold keywords.
				bold_keywords = false,
				-- Enable italic comments.
				italic_comments = true,
				-- Enable editor background transparency.
				transparent = {
					-- Enable transparent background.
					bg = false,
					-- Enable transparent background for floating windows.
					float = false,
				},
				bright_border = false,
				swap_backgrounds = false,
				reduced_blue = true,
				telescope = {
					style = "flat",
				},
				noice = {
					-- Available styles: `classic`, `flat`.
					style = "flat",
				},
				ts_context = {
					-- Enables dark background for treesitter-context window
					dark_background = true,
				},
			}
		end,
		config = function(_, opts)
			local nordic = require("nordic")
			nordic.setup(opts)
			require("nordic.colors")
			nordic.load(opts)
		end,
	},
}
