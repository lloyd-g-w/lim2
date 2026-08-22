vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
})

require("oil").setup()

-- vim.keymap.set("n", "<leader>fe", MiniFiles.open, { desc = "Open oil.nvim" })
vim.keymap.set("n", "<leader>fe", "<Cmd>Oil", { desc = "Open oil.nvim" })
