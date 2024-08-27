return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			-- Plugin and UI to automatically install LSPs to stdpath
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			-- Install neodev for better nvim configuration and plugin authoring via lsp configurations
			"folke/neodev.nvim",
			"stevearc/conform.nvim",
		},
		config = function()
			local conform = require("conform")
			local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds -- Has to load keymaps before pluginslsp

			-- Use neodev to configure lua_ls in nvim directories - must load before lspconfig
			require("neodev").setup()

			-- Setup mason so it can manage 3rd party LSP servers
			require("mason").setup({
				ui = {
					border = "rounded",
				},
			})

			-- Configure mason to auto install servers
			require("mason-lspconfig").setup({
				automatic_installation = { exclude = { "ocamllsp", "gleam" } },
			})

			-- Override tsserver diagnostics to filter out specific messages

			-- LSP servers to install (see list here: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers )
			local servers = {
				bashls = {},
				cssls = {},
				clangd = {
					cmd = { "--offset-encoding=utf-32" },
				},
				gleam = {},
				graphql = {},
				html = {},
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enabled = false },
						},
					},
				},
				marksman = {},
				ocamllsp = {},
				prismals = {},
				pyright = {
					settings = {
						-- pyright settings
						pyright = {
							disableOrganizeImports = true, -- Using Ruff
						},
						python = {
							analysis = {
								ignore = { "*" }, -- Using Ruff
								typeCheckingMode = "standard",
							},
						},
					},
				},
				ruff = {},
				-- rust_analyzer = {},
				solidity = {},
				sqlls = {},
				tailwindcss = {
					-- filetypes = { "reason" },
				},
				tsserver = {
					settings = {
						experimental = {
							enableProjectDiagnostics = true,
						},
					},
					handlers = {
						["textDocument/publishDiagnostics"] = {},
					},
				},
				yamlls = {},
				zls = {},
			}

			-- Default handlers for LSP
			local default_handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			}

			-- nvim-cmp supports additional completion capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local default_capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			---@diagnostic disable-next-line: unused-local
			local on_attach = function(_client, buffer_number)
				-- Pass the current buffer to map lsp keybinds
				map_lsp_keybinds(buffer_number)

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(buffer_number, "Format", function(_)
					require("conform").format({ bufnr = buffer_number })
				end, { desc = "Format current buffer with LSP" })
			end

			-- Iterate over our servers and set them up
			for name, config in pairs(servers) do
				require("lspconfig")[name].setup({
					capabilities = default_capabilities,
					filetypes = config.filetypes,
					handlers = vim.tbl_deep_extend("force", {}, default_handlers, config.handlers or {}),
					on_attach = on_attach,
					settings = config.settings,
					vim.lsp.inlay_hint.enable(true),
				})
			end

			-- Congifure LSP linting, formatting, diagnostics, and code actions

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_lsp" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					rust = { "rustfmt" },
					c = { "clang_format" },
					cpp = { "clang_format" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})

			-- Configure borderd for LspInfo ui
			require("lspconfig.ui.windows").default_options.border = "rounded"

			-- Configure diagostics border
			vim.diagnostic.config({
				float = {
					border = "rounded",
				},
			})
		end,
	},
}
