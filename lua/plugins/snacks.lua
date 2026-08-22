vim.pack.add({ "https://github.com/folke/snacks.nvim" })

local Snacks = require("snacks")

Snacks.setup({
	lazygit = {},
})

vim.keymap.set("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Open lazygit" })
