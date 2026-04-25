local parsers = {
	"bash",
	"c",
	"cpp",
	"cuda",
	"cmake",
	"css",
	"gleam",
	"graphql",
	"go",
	"html",
	"javascript",
	"json",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"ninja",
	"ocaml",
	"ocaml_interface",
	"prisma",
	"python",
	"rust",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			if type(ts.install) == "function" then
				ts.install(parsers)
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
					pcall(function()
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end)
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "V",
					},
				},
			})

			local select = require("nvim-treesitter-textobjects.select").select_textobject
			local selections = {
				aa = "@parameter.outer",
				ia = "@parameter.inner",
				af = "@function.outer",
				["if"] = "@function.inner",
				ac = "@class.outer",
				ic = "@class.inner",
			}
			for lhs, capture in pairs(selections) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select(capture, "textobjects")
				end, { desc = "Select " .. capture })
			end

			local move = require("nvim-treesitter-textobjects.move")
			local pair = function(key, fn, capture, desc)
				vim.keymap.set({ "n", "x", "o" }, key, function()
					fn(capture, "textobjects")
				end, { desc = desc })
			end
			pair("]m", move.goto_next_start, "@function.outer", "Next function start")
			pair("]M", move.goto_next_end, "@function.outer", "Next function end")
			pair("[m", move.goto_previous_start, "@function.outer", "Prev function start")
			pair("[M", move.goto_previous_end, "@function.outer", "Prev function end")
			pair("]]", move.goto_next_start, "@class.outer", "Next class start")
			pair("][", move.goto_next_end, "@class.outer", "Next class end")
			pair("[[", move.goto_previous_start, "@class.outer", "Prev class start")
			pair("[]", move.goto_previous_end, "@class.outer", "Prev class end")
		end,
	},
}
