return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"stevearc/conform.nvim",
			{ "j-hui/fidget.nvim", tag = "legacy" },
		},
		config = function()
			local conform = require("conform")
			local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds

			require("neodev").setup()

			require("mason").setup({ ui = { border = "rounded" } })
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"clangd",
					"jsonls",
					"lua_ls",
					"marksman",
					"pyright",
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

			local default_handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			}
			local capabilities = vim.lsp.protocol.make_client_capabilities()

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
				pyright = {
					settings = {
						pyright = { disableOrganizeImports = true },
						python = { analysis = { ignore = { "*" }, typeCheckingMode = "standard" } },
					},
				},
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
					capabilities = capabilities,
					filetypes = cfg.filetypes,
					handlers = vim.tbl_deep_extend("force", {}, default_handlers, cfg.handlers or {}),
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
					map_lsp_keybinds(bufnr)
					vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
						conform.format({ bufnr = bufnr })
					end, { desc = "Format current buffer with LSP/Conform" })
				end,
			})

			vim.lsp.inlay_hint.enable(true)

			require("lspconfig.ui.windows").default_options.border = "rounded"
			vim.diagnostic.config({ float = { border = "rounded" } })

			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_lsp" },
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
