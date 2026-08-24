-- ui2: Neovim 0.12's experimental redesign of the message + cmdline UI
-- (no hit-enter prompts, cmdline highlighted as you type, :messages pager
-- as a real buffer). Still experimental — drop this line if messages
-- start misbehaving. See :h ui2.
require("vim._core.ui2").enable()

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
	highlights = {
		-- snacks indent guides default to loud link targets that clash with
		-- onedark; pull them from the theme's own palette instead.
		SnacksIndent = { fg = "$bg3" },
		SnacksIndentScope = { fg = "$light_grey" },
	},
})
require("onedark").load()

--- Colourizer ---

vim.pack.add({
	"https://github.com/catgoose/nvim-colorizer.lua",
})

require("colorizer").setup({
	filetypes = {
		"*", -- Highlight all files, but customize some others.
		css = { rgb_fn = true, oklch_fn = true }, -- Enable parsing rgb(...) and oklch(...) functions in css.
	},
})
