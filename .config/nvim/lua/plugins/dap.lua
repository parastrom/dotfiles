local function define_colors()
	vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#b91c1c" })
	vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" })
	vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bold = true })

	vim.fn.sign_define("DapBreakpoint", {
		text = "🔴",
		numhl = "DapBreakpoint",
	})
	vim.fn.sign_define("DapBreakpointCondition", {
		text = "🔴",
		linehl = "DapBreakpoint",
		numhl = "DapBreakpoint",
	})
	vim.fn.sign_define("DapBreakpointRejected", {
		text = "🔘",
		linehl = "DapBreakpoint",
		numhl = "DapBreakpoint",
	})
	vim.fn.sign_define("DapStopped", {
		text = "🟢",
		linehl = "DapStopped",
		numhl = "DapStopped",
	})
	vim.fn.sign_define("DapLogPoint", {
		text = "🟣",
		linehl = "DapLogPoint",
		numhl = "DapLogPoint",
	})
end

local function setup_default_configurations()
	local dap = require("dap")
	local lldb_configuration = {
		{
			name = "Launch",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
		},
	}

	dap.configurations.c = lldb_configuration
	dap.configurations.cpp = lldb_configuration
	dap.configurations.rust = lldb_configuration
	dap.configurations.asm = lldb_configuration
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				types = true,
			},
			"nvim-neotest/nvim-nio",
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {
					enabled = true,
				},
			},
			"williamboman/mason.nvim",
			"folke/edgy.nvim",
		},
		config = function()
			require("dapui").setup(opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
				require("edgy").close()
			end
			-- dap.listeners.before.event_terminated["dapui_config"] = function()
			-- 	dapui.close()
			-- end
			-- dap.listeners.before.event_exited["dapui_config"] = function()
			-- 	dapui.close()
			-- end

			define_colors()

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
			vim.keymap.set("n", "<F9>", dap.restart)
			vim.keymap.set("n", "<F10>", dap.terminate)

			local codelldb_path = "/usr/local/bin/codelldb"
			local codelldb_exists = vim.fn.filereadable(codelldb_path) == 1

			dap.adapters.lldb = {
				type = "executable",
				port = "${port}",
				executable = {
					command = codelldb_path,
					args = { "--port", "${port}" },
				},
			}

			if not codelldb_exists then
				vim.notify("codelldb not found. Please install it using :MasonInstall codelldb", vim.log.levels.WARN)
			end

			vim.keymap.set("n", "<F6>", function()
				setup_default_configurations()
				-- when debug is called firstly try to read and/or update launch.json configuration
				-- from the local project which will override all the default configurations
				if vim.fn.filereadable(".vscode/launch.json") then
					require("dap.ext.vscode").load_launchjs(nil, { lldb = { "rust", "c", "cpp" } })
				else
					-- If not possible stick to the default prebuilt configurations
					setup_default_configurations()
				end

				require("dap").continue()
			end)
		end,
	},
}
