vim.pack.add({
	"https://github.com/folke/noice.nvim",

	-- Deps
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
})

require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = false, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})

require("telescope").load_extension("noice")
vim.keymap.set("n", "<leader>fn", "<Cmd>Telescope noice<CR>", { desc = "Telescope noice" })

---

vim.pack.add({
	"https://github.com/Bekaboo/dropbar.nvim",
})

require("dropbar").setup({})

---

vim.pack.add({
	"https://github.com/goolord/alpha-nvim",
})

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- `:colorscheme` runs `hi clear` internally, which would wipe this link if
-- set only once here — reapply it every time the colorscheme (re)loads.
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "AlphaHeader", { link = "Keyword" })
	end,
})
vim.api.nvim_set_hl(0, "AlphaHeader", { link = "Keyword" })

dashboard.section.header.val = {
	[[ ██╗     ██╗███╗   ███╗ ]],
	[[ ██║     ██║████╗ ████║ ]],
	[[ ██║     ██║██╔████╔██║ ]],
	[[ ██║     ██║██║╚██╔╝██║ ]],
	[[ ███████╗██║██║ ╚═╝ ██║ ]],
	[[ ╚══════╝╚═╝╚═╝     ╚═╝ ]],
}

dashboard.section.header.opts.hl = "AlphaHeader"

dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", "<cmd>ene <BAR> startinsert<CR>"),
	dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
	dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
	dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
}

alpha.setup(dashboard.opts)

---
vim.pack.add({
	-- 'https://github.com/nvim-tree/nvim-web-devicons',
	"https://github.com/nvim-lualine/lualine.nvim",
})

require("lualine").setup({
	options = {
		theme = "onedark",
		section_separators = { "" },
		component_separators = { "" },
	},
})

------- COLOURSCHEMES -------

vim.pack.add({
	"https://github.com/navarasu/onedark.nvim",
})
require("onedark").setup({
	style = "warm",
})
require("onedark").load()
