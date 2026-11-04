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
flash.setup({
	modes = {
		-- Off by default upstream; this is what puts jump labels on `/` and `?` matches.
		search = { enabled = true },
		-- f/t/F/T/;/, are left to flash's char mode (on by default) rather than
		-- remapped to jump(), so they keep their normal semantics plus labels.
		char = { jump_labels = true },
	},
})

-- <CR> is also how quickfix/help/terminal buffers "open" things, so only take it over
-- in normal file buffers.
vim.keymap.set({ "n", "x", "o" }, "<CR>", function()
	if vim.bo.buftype ~= "" then
		vim.api.nvim_feedkeys(vim.keycode("<CR>"), "n", false)
	else
		flash.jump()
	end
end, { desc = "Flash" })
-- `S` rather than `s`: mini.surround owns the `s` prefix (sa/sd/sr...).
vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash treesitter" })
vim.keymap.set("o", "r", flash.remote, { desc = "Remote flash" })
vim.keymap.set({ "o", "x" }, "R", flash.treesitter_search, { desc = "Treesitter search" })
vim.keymap.set("c", "<C-s>", flash.toggle, { desc = "Toggle flash search" })
