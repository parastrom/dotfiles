return {
	{
		"saghen/blink.cmp",
		lazy = false, -- lazy loading handled internally
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		event = "InsertEnter",
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
