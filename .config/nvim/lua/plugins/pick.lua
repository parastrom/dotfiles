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

						local width = math.floor(cols) -- 100% of width
						local height = math.floor(lines * 0.20) -- 70% of height

						return {
							anchor = "NW",
							width = width,
							height = height,
							row = lines - height - 1,
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
