return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			require("dapui").setup()
			local dap = require("dap")
			local dapui = require("dapui")
			-- Define sign icons for breakpoints
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)
			vim.keymap.set("n", "<leader>?", function()
				require("dapui").eval(nil, { enter = true })
			end)
			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F10>", dap.restart)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			-- dap.listeners.before.event_terminated["dapui_config"] = function()
			--   dapui.close()
			-- end
			-- dap.listeners.before.event_exited["dapui_config"] = function()
			--   dapui.close()
			-- end

			local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/codelldb"
			local codelldb_exists = vim.fn.filereadable(codelldb_path) == 1

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = codelldb_exists and {
					command = codelldb_path,
					args = { "--port", "${port}" },
				} or nil,
			}

			if not codelldb_exists then
				vim.notify("codelldb not found. Please install it using :MasonInstall codelldb", vim.log.levels.WARN)
			end
		end,
	},
}
