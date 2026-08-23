vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	-- Snippet bodies (not an engine) — mini.snippets' language loader
	-- reads its json/lua snippet files directly.
	"https://github.com/rafamadriz/friendly-snippets",
})

require("mini.ai").setup({})
require("mini.pairs").setup({})
require("mini.surround").setup({})
require("mini.extra").setup({})
require("mini.hipatterns").setup({})
require("mini.cursorword").setup({})
require("mini.move").setup({})
require("mini.icons").setup({})
require("mini.git").setup({})
require("mini.diff").setup({})
require("mini.trailspace").setup({})
require("mini.jump2d").setup({})

--- Snippets ---

local snippets = require("mini.snippets")

-- A few hand snippets that don't exist in friendly-snippets, kept small
-- on purpose — mini.snippets' LSP-style bodies can't express the
-- dynamic/regex triggers the old LuaSnip config used, so only the plain
-- static ones were worth carrying over.
local custom_by_filetype = {
	c = { { prefix = "bigcomment", body = "// ==================== $1 ==================== //", desc = "Banner comment" } },
	typst = {
		{ prefix = "mk", body = "$ $1 $", desc = "Inline math" },
		{ prefix = "dm", body = { "$", "  $1", "  .", "$" }, desc = "Display math" },
	},
}
custom_by_filetype.cpp = custom_by_filetype.c
custom_by_filetype.java = custom_by_filetype.c

snippets.setup({
	snippets = {
		snippets.gen_loader.from_lang(),
		function()
			return custom_by_filetype[vim.bo.filetype] or {}
		end,
	},
	-- Same keys as lim's LuaSnip setup (expand/jump-forward/jump-back).
	mappings = { expand = "<C-k>", jump_next = "<C-l>", jump_prev = "<C-j>" },
})
