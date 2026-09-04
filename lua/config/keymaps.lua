-- Clear an annoying default keybind (join-lines-with-comment-leader).
vim.keymap.set("n", "<S-j>", "<Nop>")

-- Exit terminal mode without a plugin.
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

-- Quickfix list navigation.
vim.keymap.set("n", "<leader>co", "<cmd>copen<cr>", { silent = true, desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>cc", "<cmd>cclose<cr>", { silent = true, desc = "Close quickfix list" })
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<cr>", { silent = true, desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<cr>", { silent = true, desc = "Previous quickfix item" })

-- Diagnostics (built into Neovim's LSP client, no plugin required).
vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, { silent = true, desc = "Open diagnostic" })
vim.keymap.set("n", "<leader>dn", function()
	vim.diagnostic.jump({ count = 1 })
end, { silent = true, desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dp", function()
	vim.diagnostic.jump({ count = -1 })
end, { silent = true, desc = "Previous diagnostic" })

-- Cycle the current split through useful fractions of the editor width.
local window_widths = { 1 / 4, 1 / 3, 1 / 2, 1 }
vim.keymap.set("n", "<C-w>R", function()
	local index = (vim.w.width_cycle_index or 0) % #window_widths + 1
	vim.w.width_cycle_index = index

	local target_width = math.floor(vim.o.columns * window_widths[index] + 0.5)
	vim.api.nvim_win_set_width(0, target_width)
end, { silent = true, desc = "Cycle window width (1/4, 1/3, 1/2, full)" })

-- Term
vim.keymap.set("t", "<C-Space>", "<Cmd>stopinsert<CR>", { silent = true }) -- Exit term
