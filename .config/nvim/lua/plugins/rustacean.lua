return {
	{
		"mrcjkb/rustaceanvim",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-lua/plenary.nvim",
		},
		version = "^5",
		ft = { "rust" },
		opts = {
			server = {
				---@diagnostic disable-next-line: unused-local
				on_attach = function(client, bufnr)
					local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds
					map_lsp_keybinds(bufnr)
					vim.keymap.set("n", "<leader>dr", function()
						vim.cmd.RustLsp("debuggables")
					end, { buffer = bufnr, desc = "Rust: Run Debuggables" })
					vim.keymap.set("n", "<leader>rr", function()
						vim.cmd.RustLsp("runnables")
					end, { buffer = bufnr, desc = "Rust: Run Runnables" })
					vim.keymap.set("n", "<leader>tr", function()
						vim.cmd.RustLsp("testables")
					end, { buffer = bufnr, desc = "Rust: Run Testables" })

					vim.lsp.inlay_hint.enable(true)
				end,
				capabilities = (function()
					local capabilities = vim.lsp.protocol.make_client_capabilities()
					return require("cmp_nvim_lsp").default_capabilities(capabilities)
				end)(),
				settings = {
					["rust-analyzer"] = {
						cargo = {
							loadOutDirsFromCheck = true,
							buildScripts = {
								enable = true,
							},
						},
						-- Add clippy lints
						procMacro = {
							enable = true,
							ignored = {
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
							},
						},
						diagnostics = {
							enable = true,
							experimental = {
								enable = true,
							},
						},
					},
				},
			},
			tools = {
				hover_actions = {
					auto_focus = true,
				},
			},
		},
		config = function(_, opts)
			vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
			vim.diagnostic.config({
				float = {
					border = "rounded",
				},
			})
		end,
	},
}
