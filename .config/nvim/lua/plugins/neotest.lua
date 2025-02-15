return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"williamboman/mason.nvim",
		},
		vim.keymap.set("n", "<leader>to", function()
			require("neotest").output_panel.toggle()
		end, { desc = "Neotest: open test output panel" }),

		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("neotest").setup({
				output_panel = {
					enabled = true,
					open = "botright vsplit | vertical resize 80",
					open_on_run = "true",
				},
			})
		end,
	},
}
