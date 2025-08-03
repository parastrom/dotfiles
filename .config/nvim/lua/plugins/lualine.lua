return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			local function truncate_branch_name(branch)
				if not branch or branch == "" then
					return ""
				end

				-- Match the branch name to the specified format
				local _, _, ticket_number = string.find(branch, "skdillon/sko%-(%d+)%-")

				-- If the branch name matches the format, display sko-{ticket_number}, otherwise display the full branch name
				if ticket_number then
					return "sko-" .. ticket_number
				else
					return branch
				end
			end

			require("lualine").setup({
				options = {
					theme = "auto",
					globalstatus = true,
					component_separators = { left = "█", right = "█" },
					section_separators = { left = "█", right = "█" },
				},
				sections = {
					lualine_b = {
						{ "branch", icon = "", fmt = truncate_branch_name },
						"diff",
						"diagnostics",
					},
					lualine_c = {
						{ "filename", path = 1 },
					},
					lualine_x = {
						{
							require("noice").api.status.message.get_hl,
							cond = require("noice").api.status.message.has,
						},
						{
							require("noice").api.status.command.get,
							cond = require("noice").api.status.command.has,
							color = { fg = "#ff9e64" },
						},
						{
							require("noice").api.status.mode.get,
							cond = require("noice").api.status.mode.has,
							color = { fg = "#ff9e64" },
						},
						{
							require("noice").api.status.search.get,
							cond = require("noice").api.status.search.has,
							color = { fg = "#ff9e64" },
						},
					},
				},
			})
		end,
	},
}
