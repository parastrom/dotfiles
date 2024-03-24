return {
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			local notify = require("notify")

			local filtered_message = { "No information available" }

			-- Override notify function to filter out messages
			---@diagnostic disable-next-line: duplicate-set-field
			vim.notify = function(message, level, opts)
				local merged_opts = vim.tbl_extend("force", {
					on_open = function(win)
						local buf = vim.api.nvim_win_get_buf(win)
						vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
					end,
				}, opts or {})

				for _, msg in ipairs(filtered_message) do
					if message == msg then
						return
					end
				end
				return notify(message, level, merged_opts)
			end

			-- Update colors to use Rose Pine colors
			vim.cmd([[
        highlight NotifyERRORBorder guifg=#eb6f92
        highlight NotifyERRORIcon guifg=#eb6f92
        highlight NotifyERRORTitle guifg=#eb6f92
        highlight NotifyINFOBorder guifg=#9ccfd8
        highlight NotifyINFOIcon guifg=#9ccfd8
        highlight NotifyINFOTitle guifg=#9ccfd8
        highlight NotifyWARNBorder guifg=#f6c177
        highlight NotifyWARNIcon guifg=#f6c177
        highlight NotifyWARNTitle guifg=#f6c177
      ]])
		end,
	},
}

