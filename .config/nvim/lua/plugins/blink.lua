return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "v1.*",
		opts = {
			completion = {
				accept = { auto_brackets = { enabled = true } },
				trigger = { show_on_insert_on_trigger_character = false },
			},
			signature = { enabled = true },
			keymap = {
				["<CR>"] = { "accept", "fallback" },
				["<C-j>"] = { "select_next" },
				["<C-k>"] = { "select_prev" },
			},
		},
		config = function(_, opts)
			require("blink.cmp").setup(opts)
		end,
	},
}
