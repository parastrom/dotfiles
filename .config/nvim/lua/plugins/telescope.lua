return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				-- This will not install any breaking changes.
				-- For major updates, this must be adjusted manually.
				version = "^1.0.0",
			},
		},
		config = function()
			local actions = require("telescope.actions")
			local telescope = require("telescope")

			local border_chars_telescope_prompt_thin = { "▔", "▕", " ", "▏", "🭽", "🭾", "▕", "▏" }
			local border_chars_telescope_vert_preview_thin = { " ", "▕", "▁", "▏", "▏", "▕", "🭿", "🭼" }
			local border_chars_outer_thin_telescope = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" }

			telescope.setup({
				defaults = {
					layout_strategy = "flex", -- Changed to flex for better responsiveness
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = function(_, cols, _)
								if cols < 120 then
									return math.floor(cols * 0.4)
								else
									return math.floor(cols * 0.5)
								end
							end,
							width = function(_, cols, _)
								if cols < 120 then
									return math.floor(cols * 0.9)
								else
									return math.floor(cols * 0.75)
								end
							end,
						},
						vertical = {
							mirror = true,
							preview_height = 0.4,
						},
						flex = {
							flip_columns = 120, -- Switch to vertical layout if window is narrower than this
						},
						width = function(_, cols, _)
							if cols < 120 then
								return math.floor(cols * 0.9)
							else
								return math.floor(cols * 0.75)
							end
						end,
						height = function(_, _, lines)
							if lines < 40 then
								return math.floor(lines * 0.8)
							else
								return math.floor(lines * 0.6)
							end
						end,
						preview_cutoff = 80, -- Reduced cutoff for smaller screens
					},
					borderchars = {
						prompt = border_chars_telescope_prompt_thin,
						preview = border_chars_telescope_vert_preview_thin,
						results = border_chars_outer_thin_telescope,
					},
					sorting_strategy = "ascending",
					border = true,
					multi_icon = "",
					entry_prefix = " ",
					prompt_prefix = " ",
					selection_caret = ">",
					results_title = "",
					preview_title = "",
					winblend = 0,
					wrap_results = true,
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-x>"] = actions.delete_buffer,
							["<Esc>"] = actions.close,
						},
					},
					file_ignore_patterns = {
						"node_modules",
						"yarn.lock",
						".git",
						".sl",
						"_build",
						".next",
					},
					hidden = true,
				},
				pickers = {
					buffers = {
						preview = false,
						wrap_results = false,
						layout_config = {
							height = 0.4,
							width = 0.5,
						},
						sort_mru = true,
						preview_title = "",
						ignore_current_buffer = true,
					},
					find_files = {
						preview_title = "",
					},
					live_grep = {
						preview_title = "",
					},
				},
			})

			-- Enable telescope fzf native, if installed
			require("telescope").load_extension("live_grep_args")
			require("telescope").load_extension("notify")
			pcall(require("telescope").load_extension, "projects")
			pcall(require("telescope").load_extension, "ui-select")

			-- Add line numbers to preview
			vim.api.nvim_create_autocmd("User", {
				pattern = "TelescopePreviewerLoaded",
				callback = function()
					vim.opt_local.number = true
				end,
			})
		end,
	},
}
