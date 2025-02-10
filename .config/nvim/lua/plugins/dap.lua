return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"plenary.nvim", -- Added for VSCode launch.json support
		},
		config = function()
			require("dapui").setup(opts)
			local dap = require("dap")
			local dapui = require("dapui")

			-- Keep your sign definitions
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "" })

			-- Keep your keybindings
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

			-- DAP UI listeners
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.rust = {
				{
					name = "Debug with codelldb",
					type = "codelldb",
					request = "launch",
					program = function()
						return nil -- Let Rustaceanvim handle this
					end,
					cwd = function()
						local current_file = vim.fn.expand("%:p")
						local cargo_toml_dir = vim.fn.finddir("Cargo.toml", current_file .. ";")
						if cargo_toml_dir == "" then
							vim.notify("Failed to locate Cargo.toml. Using the current directory.", vim.log.levels.WARN)
							return vim.fn.getcwd()
						end
						return vim.fn.fnamemodify(cargo_toml_dir, ":h")
					end,
					stopOnEntry = false,
					env = {
						RUST_BACKTRACE = "1",
					},
				},
			}

			if not codelldb_exists then
				vim.notify("codelldb not found. Please install it using :MasonInstall codelldb", vim.log.levels.WARN)
			end
		end,
	},
}
