vim.pack.add({
	"https://github.com/Saghen/blink.cmp",
})

require("blink.cmp").setup({
	-- Lua fuzzy matcher instead of the prebuilt Rust one — no
	-- separate download/build step needed on top of vim.pack.
	fuzzy = { implementation = "lua" },

	-- Expand via mini.snippets (lua/plugins/mini.lua) instead of
	-- blink's own snippet store.
	snippets = { preset = "mini_snippets" },

	keymap = { preset = "default" },
	signature = { enabled = true },
})
