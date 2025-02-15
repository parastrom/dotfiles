return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			cmdline = {
				view = "cmdline",
			},
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
			},
			views = {
				-- Clean cmdline_popup + palette
				cmdline_popup = {
					position = {
						row = 10,
						col = "50%",
					},
					border = {
						style = "none",
						padding = { 2, 3 },
					},
					size = {
						min_width = 60,
						width = "auto",
						height = "auto",
					},
					win_options = {
						winhighlight = { NormalFloat = "NormalFloat", FloatBorder = "FloatBorder" },
					},
				},
				cmdline_popupmenu = {
					relative = "editor",
					position = {
						row = 13,
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
						max_height = 15,
					},
					border = {
						style = "none",
						padding = { 0, 3 },
					},
					win_options = {
						winhighlight = { NormalFloat = "NormalFloat", FloatBorder = "NoiceCmdlinePopupBorder" },
					},
				},
				hover = {
					border = {
						style = "single",
					},
				},
				confirm = {
					border = {
						style = "single",
					},
				},
				popup = {
					border = {
						style = "single",
					},
				},
			},
		},
		config = function(_, opts)
			require("noice").setup(opts)
		end,
	},
}
