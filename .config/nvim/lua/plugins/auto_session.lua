return {
	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions",
				auto_session_enabled = true,
			})
		end,
	},
}
