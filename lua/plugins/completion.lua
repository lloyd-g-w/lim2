vim.pack.add({
	-- blink.cmp v2 split shared utilities out into blink.lib — it's a
	-- hard dependency, not optional.
	"https://github.com/Saghen/blink.lib",
	"https://github.com/Saghen/blink.cmp",
})

require("blink.cmp").setup({
	-- Lua fuzzy matcher instead of the prebuilt Rust one — no
	-- separate download/build step needed on top of vim.pack.
	fuzzy = { implementation = "lua" },

	-- Use LuaSnip for expansion and as Blink's snippet completion source.
	snippets = { preset = "luasnip" },

	-- Mirrors the old lim nvim-cmp keymap 1:1: Tab/S-Tab only move
	-- through the menu (snippet jumping is its own thing, bound
	-- alongside LuaSnip in snippets.lua), Enter only accepts an
	-- explicitly-selected item, and C-b/C-f scroll docs.
	keymap = {
		["<C-space>"] = { "show" },
		["<C-e>"] = { "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
	},

	completion = {
		list = { selection = { preselect = false } },

		menu = {
			-- border = "single",
			draw = {
				padding = { 0, 1 },
				gap = 1,

				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind" },
				},

				components = {
					kind_icon = {
						text = function(ctx)
							return ctx.kind_icon .. ctx.icon_gap .. " "
						end,
					},
				},
			},
		},
	},
	-- Mode-specific config layers over the global one, and blink v2 ships
	-- a cmdline-mode default of preselect = true that beats the global
	-- `preselect = false` above — making Tab skip the first candidate.
	-- Nothing gets selected until the first Tab, in every mode.
	cmdline = {
		completion = {
			list = { selection = { preselect = false } },
		},
	},

	signature = { enabled = true },
})
