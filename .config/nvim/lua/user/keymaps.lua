local nnoremap = require("user.keymap_utils").nnoremap
local vnoremap = require("user.keymap_utils").vnoremap
local inoremap = require("user.keymap_utils").inoremap
local tnoremap = require("user.keymap_utils").tnoremap
local xnoremap = require("user.keymap_utils").xnoremap
local illuminate = require("illuminate")
local utils = require("user.utils")

local M = {}

local TERM = os.getenv("TERM")

-- Normal --
-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")

-- Window navigation
nnoremap("<C-h>", require("smart-splits").move_cursor_left)
nnoremap("<C-j>", require("smart-splits").move_cursor_down)
nnoremap("<C-k>", require("smart-splits").move_cursor_up)
nnoremap("<C-l>", require("smart-splits").move_cursor_right)

nnoremap("<leader><leader>h", require("smart-splits").swap_buf_left)
nnoremap("<leader><leader>j", require("smart-splits").swap_buf_down)
nnoremap("<leader><leader>k", require("smart-splits").swap_buf_up)
nnoremap("<leader><leader>l", require("smart-splits").swap_buf_right)

-- Swap between last two buffers
nnoremap("<leader>'", "<C-^>", { desc = "Switch to last buffer" })

-- Save with leader key
nnoremap("<leader>w", "<cmd>w<cr>", { silent = false })

-- Quit with leader key
nnoremap("<leader>q", "<cmd>q<cr>", { silent = false })

-- Save and Quit with leader key
nnoremap("<leader>z", "<cmd>wq<cr>", { silent = false })

-- Map Oil to <leader>e
nnoremap("<leader>e", function()
	require("oil").toggle_float()
end)

-- Center buffer while navigating
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("{", "{zz")
nnoremap("}", "}zz")
nnoremap("N", "Nzz")
nnoremap("n", "nzz")
nnoremap("G", "Gzz")
nnoremap("gg", "ggzz")
nnoremap("<C-i>", "<C-i>zz")
nnoremap("<C-o>", "<C-o>zz")
nnoremap("%", "%zz")
nnoremap("*", "*zz")
nnoremap("#", "#zz")

-- Press 'S' for quick find/replace for the word under the cursor
nnoremap("S", function()
	local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
	local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end)

-- Open Spectre for global find/replace
nnoremap("<leader>S", function()
	require("spectre").toggle()
end)

-- Open Spectre for global find/replace for the word under the cursor in normal mode
nnoremap("<leader>sw", function()
	require("spectre").open_visual({ select_word = true })
end, { desc = "Search current w/rd" })

-- Open Spectre for global find/replace for the word under the cursor in visual mode
vnoremap("<leader>sw", function()
	require("spectre").open_visual({ select_word = true })
end, { desc = "Search current word" })

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
nnoremap("L", "$")
nnoremap("H", "^")

-- Press 'U' for undo
nnoremap("U", "<C-r>")

-- Turn off highlighted results
nnoremap("<leader>no", "<cmd>noh<cr>")

-- Diagnostics

-- Goto next diagnostic of any severity
nnoremap("]d", function()
	vim.diagnostic.goto_next({})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous diagnostic of any severity
nnoremap("[d", function()
	vim.diagnostic.goto_prev({})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next error diagnostic
nnoremap("]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous error diagnostic
nnoremap("[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next warning diagnostic
nnoremap("]w", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous warning diagnostic
nnoremap("[w", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

nnoremap("<leader>d", function()
	vim.diagnostic.open_float({
		border = "rounded",
	})
end)

nnoremap("<leader>bd", "<cmd>bprevious<cr><cmd>bdelete #<cr>", { desc = "[B]uffer [D]elete" })
-- Place all dignostics into a qflist
nnoremap("<leader>ld", vim.diagnostic.setqflist, { desc = "Quickfix [L]ist [D]iagnostics" })

-- Navigate to next qflist item
nnoremap("<leader>cn", ":cnext<cr>zz")

-- Navigate to previos qflist item
nnoremap("<leader>cp", ":cprevious<cr>zz")

-- Open the qflist
nnoremap("<leader>co", ":copen<cr>zz")

-- Close the qflist
nnoremap("<leader>cc", ":cclose<cr>zz")

-- Map MaximizerToggle (szw/vim-maximizer) to leader-m
nnoremap("<leader>m", ":MaximizerToggle<cr>")

-- Resize split windows to be equal size
nnoremap("<leader>=", "<C-w>=")

-- Create new vertical window
nnoremap("<leader>wv", "<C-w>v")

-- Create new horizontal window
nnoremap("<leader>ws", "<C-w>s")

--Hide the current window
nnoremap("<leader>h", ":hide<CR>")

-- Press leader f to format
nnoremap("<leader>f", ":Format<cr>")

-- Press leader rw to rotate open windows
nnoremap("<leader>rw", ":RotateWindows<cr>", { desc = "[R]otate [W]indows" })

-- Press gx to open the link under the cursor
nnoremap("gx", ":sil !open <cWORD><cr>", { silent = true })

-- Git keymaps --
nnoremap("<leader>gb", ":Gitsigns toggle_current_line_blame<cr>")
nnoremap("<leader>gf", function()
	local cmd = {
		"sort",
		"-u",
		"<(git diff --name-only --cached)",
		"<(git diff --name-only)",
		"<(git diff --name-only --diff-filter=U)",
	}

	if not utils.is_git_directory() then
		vim.notify(
			"Current project is not a git directory",
			vim.log.levels.WARN,
			{ title = "Telescope Git Files", git_command = cmd }
		)
	else
		require("telescope.builtin").git_files()
	end
end, { desc = "Search [G]it [F]iles" })

-- Telescope keybinds --

-- [S]earch [F]iles
nnoremap("<leader>sf", function()
	require("mini.pick").builtin.files()
end, { desc = "[S]earch [F]iles" })

-- [S]earch by [G]rep (live)
nnoremap("<leader>sg", function()
	require("mini.pick").builtin.grep_live()
end, { desc = "[S]earch by [G]rep" })

-- [S]earch Open [B]uffers
nnoremap("<leader>sb", function()
	require("mini.pick").builtin.buffers()
end, { desc = "[S]earch Open [B]uffers" })

nnoremap("<leader>?", function()
	require("mini.extra").pickers.oldfiles()
end, { desc = "[?] Find recently opened files" })

nnoremap("<leader>sh", function()
	require("mini.pick").builtin.help()
end, { desc = "[S]earch [H]elp" })

nnoremap("<leader>sd", function()
	require("mini.extra").pickers.diagnostic()
end, { desc = "[S]earch [D]iagnostics" })

nnoremap("<leader>gf", function()
	require("mini.extra").pickers.git_files()
end, { desc = "[G]it [F]iles" })

nnoremap("<leader>sc", function()
	require("mini.extra").pickers.commands()
end, { desc = "[S]earch [C]ommands" })

-- LSP Keybinds (exports a function to be used in ../../after/plugin/lsp.lua b/c we need a reference to the current buffer) --

M.map_lsp_keybinds = function(buffer_number)
	-- Core LSP
	nnoremap("<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame", buffer = buffer_number })
	nnoremap("<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction", buffer = buffer_number })
	nnoremap("gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition", buffer = buffer_number })

	-- MiniExtra LSP pickers (preview, multi-location, etc.)
	nnoremap("gr", function()
		require("mini.extra").pickers.lsp({ scope = "references" })
	end, { desc = "LSP: [G]oto [R]eferences (picker)", buffer = buffer_number })

	nnoremap("gi", function()
		require("mini.extra").pickers.lsp({ scope = "implementation" })
	end, { desc = "LSP: [G]oto [I]mplementation (picker)", buffer = buffer_number })

	nnoremap("<leader>bs", function()
		require("mini.extra").pickers.lsp({ scope = "document_symbol" })
	end, { desc = "LSP: [B]uffer [S]ymbols (picker)", buffer = buffer_number })

	nnoremap("<leader>ps", function()
		require("mini.extra").pickers.lsp({ scope = "workspace_symbol_live" })
	end, { desc = "LSP: [P]roject [S]ymbols (live picker)", buffer = buffer_number })

	-- Hover / signatures
	nnoremap("K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation", buffer = buffer_number })
	nnoremap("<leader>k", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })
	inoremap("<C-k>", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })

	-- Lesser-used
	nnoremap("gD", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration", buffer = buffer_number })
	nnoremap("td", vim.lsp.buf.type_definition, { desc = "LSP: [T]ype [D]efinition", buffer = buffer_number })
end

-- Vim Illuminate keybinds
nnoremap("<leader>]", function()
	illuminate.goto_next_reference()
	vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Illuminate: Goto next reference" })

nnoremap("<leader>[", function()
	illuminate.goto_prev_reference()
	vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Illuminate: Goto previous reference" })

-- Visual --
-- Disable Space bar since it'll be used as the leader key
vnoremap("<space>", "<nop>")

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
vnoremap("L", "$<left>")
vnoremap("H", "^")

-- Paste without losing the contents of the register
xnoremap("<leader>p", '"_dP')

-- Move selected text up/down in visual mode
vnoremap("<A-j>", ":m '>+1<CR>gv=gv")
vnoremap("<A-k>", ":m '<-2<CR>gv=gv")

-- Reselect the last visual selection
xnoremap("<<", function()
	vim.cmd("normal! <<")
	vim.cmd("normal! gv")
end)

vnoremap("<leader>fj", ":'<,'>!jq --indent 4 '.'<CR>", { desc = "Format JSON with jq" })

xnoremap(">>", function()
	vim.cmd("normal! >>")
	vim.cmd("normal! gv")
end)

-- Terminal --
-- Enter normal mode while in a terminal
tnoremap("<esc>", [[<C-\><C-n>]])
tnoremap("jj", [[<C-\><C-n>]])

-- Reenable default <space> functionality to prevent input delay
tnoremap("<space>", "<space>")

-- Updated Trouble keymaps using the new API
nnoremap("<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble Workspace diagnostics" })
nnoremap("<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble Document diagnostics" })
nnoremap("<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Trouble Quick Fix" })
nnoremap("<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble Local List" })
nnoremap(
	"<leader>so",
	"<cmd>Trouble symbols toggle pinned=true win.relative=win win.position=right<cr>",
	{ desc = "Trouble Symbol Outline" }
)

return M
