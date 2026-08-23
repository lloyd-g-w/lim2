vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
})

require("oil").setup({
	columns = {
		"icon",
		"size",
		{ "mtime", format = "%Y-%m-%d %H:%M" },
	},
})

vim.keymap.set("n", "<leader>fe", "<Cmd>Oil<CR>", { desc = "Open oil" })

--- Telescope ---

vim.pack.add({
	"https://github.com/nvim-telescope/telescope.nvim",
	-- Deps
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

--- Flash ---
vim.pack.add({
	"https://github.com/folke/flash.nvim",
})

local flash = require("flash")
flash.setup()

vim.keymap.set({ "n", "x", "o" }, "f", flash.jump, { desc = "Flash" })
