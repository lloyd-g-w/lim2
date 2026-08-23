vim.pack.add({ "https://github.com/folke/snacks.nvim" })

local snacks = require("snacks")

snacks.setup({
	lazygit = {},
	bigfile = {},
	rename = {},
	indent = {
		enabled = true,
		animate = { enabled = false },
	},
	scope = { enabled = true },
})

vim.keymap.set("n", "<leader>gg", function()
	snacks.lazygit()
end, { desc = "Open lazygit" })
