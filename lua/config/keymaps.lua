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
