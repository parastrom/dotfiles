return {
	{
		"saghen/blink.cmp",
		lazy = false, -- lazy loading handled internally
		dependencies = {
			"rafamadriz/friendly-snippets",
			"windwp/nvim-autopairs",
		},
		event = "InsertEnter",
		version = "v0.*",
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
			trigger = { signature_help = { enabled = false, show_on_insert_on_trigger_character = false } },
		},
		config = function(_, opts)
			require("blink.cmp").setup(opts)
		end,
	},
}
