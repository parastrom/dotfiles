return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			scroll = { enabled = true },
		},
		config = function(_, opts)
			require("snacks").setup(opts)
		end,
	},
}
