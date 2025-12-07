return {
	{
		"echasnovski/mini.pick",
		version = false,
		config = function()
			local pick = require("mini.pick")
			pick.setup({
				window = {
					config = function()
						local cols = vim.o.columns
						local lines = vim.o.lines

						local width = math.floor(cols * 0.40) -- 40% of width
						local height = math.floor(lines * 0.70) -- 70% of height

						return {
							anchor = "NW",
							width = width,
							height = height,
							row = math.floor((lines - height) / 2),
							col = math.floor((cols - width) / 2),
						}
					end,
				},
				mappings = {
					move_down = "<C-j>",
					move_up = "<C-k>",
				},
			})
		end,
	},

	{
		"echasnovski/mini.extra",
		version = false,
		config = function()
			require("mini.extra").setup()
		end,
	},
}
