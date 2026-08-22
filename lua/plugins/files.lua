vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
})

require("oil").setup()

vim.keymap.set("n", "<leader>fe", "<Cmd>Oil<CR>", { desc = "Open oil" })
