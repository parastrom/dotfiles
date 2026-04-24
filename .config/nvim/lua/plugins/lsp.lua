return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"stevearc/conform.nvim",
		},
		config = function()
			local conform = require("conform")
			local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds

			require("mason").setup({ ui = { border = "rounded" } })
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"clangd",
					"jsonls",
					"lua_ls",
					"marksman",
					"ty",
					"ruff",
					"solidity",
					"sqlls",
					"ts_ls",
					"yamlls",
					"zls",
				},
				automatic_installation = true,
				automatic_enable = false,
			})

			-- server-specific diffs only
			local servers = {
				bashls = {},
				clangd = { cmd = { "clangd", "--offset-encoding=utf-32" } },
				html = {},
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enabled = false },
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
				marksman = {},
				ty = {},
				ruff = {},
				solidity = {},
				sqlls = {},
				ts_ls = {
					settings = { experimental = { enableProjectDiagnostics = true } },
					handlers = { ["textDocument/publishDiagnostics"] = {} },
				},
				yamlls = {},
				zls = {},
			}

			-- new API: register configs
			for name, cfg in pairs(servers) do
				vim.lsp.config(name, {
					filetypes = cfg.filetypes,
					handlers = cfg.handlers,
					settings = cfg.settings,
					cmd = cfg.cmd,
				})
			end

			-- start them
			vim.lsp.enable(vim.tbl_keys(servers))

			-- replace on_attach with LspAttach
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "ruff" then
						client.server_capabilities.hoverProvider = false
					end
					map_lsp_keybinds(bufnr)
					vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
						conform.format({ bufnr = bufnr })
					end, { desc = "Format current buffer with LSP/Conform" })
				end,
			})

			vim.lsp.inlay_hint.enable(true)

			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					rust = { "rustfmt" },
					c = { "clang_format" },
					cpp = { "clang_format" },
				},
				format_on_save = { timeout_ms = 500, lsp_fallback = true },
			})
		end,
	},
}
