vim.pack.add({
	"https://github.com/folke/which-key.nvim",
})

local whichkey = require("which-key")
whichkey.setup()

whichkey.add({
	{ "<leader>c", group = "Code" },
	{ "<leader>d", group = "Diagnostics" },
	{ "<leader>f", group = "Find" },
	{ "<leader>g", group = "Git" },
	{
		"<leader>?",
		function()
			require("which-key").show({ global = true })
		end,
		desc = "Buffer Keymaps (which-key)",
	},
})

--- Leetcode ---

vim.pack.add({
	"https://github.com/kawre/leetcode.nvim",

	-- Deps (plenary/nui also appear in ai.lua — vim.pack dedupes; listed
	-- here too so this section survives without that file).
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/3rd/image.nvim",
})

-- magick_cli shells out to the imagemagick in extraPackages instead of
-- building the magick luarock (see 3rd/image.nvim#91).
require("image").setup({
	processor = "magick_cli",
})

require("leetcode").setup({
	image_support = true,
})

--- Tmux support ---

vim.pack.add({
	"https://github.com/christoomey/vim-tmux-navigator",
})

-- vim-tmux-navigator is plain Vimscript (no Lua module/setup() to call) —
-- it just defines these commands; wire up the keymaps directly.
vim.keymap.set("n", "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", { silent = true })
vim.keymap.set("n", "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", { silent = true })
vim.keymap.set("n", "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", { silent = true })
vim.keymap.set("n", "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", { silent = true })
vim.keymap.set("n", "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", { silent = true })
