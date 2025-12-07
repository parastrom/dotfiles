return {
	{
		"nvim-neotest/neotest",
		lazy = true,
		cmd = { "Neotest" },
		keys = {
			{ "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Neotest: toggle output panel" },
		},
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("neotest").setup({
				output_panel = {
					enabled = true,
					open = "botright vsplit | vertical resize 80",
					open_on_run = true,
				},
			})
		end,
	},
}
