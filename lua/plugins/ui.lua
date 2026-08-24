-- ui2: Neovim 0.12's experimental redesign of the message + cmdline UI
-- (no hit-enter prompts, cmdline highlighted as you type, :messages pager
-- as a real buffer). Still experimental — drop this line if messages
-- start misbehaving. See :h ui2.
require("vim._core.ui2").enable()

--- Treesitter ---

-- The main branch replaced lazy.nvim-era `:TSUpdate`-on-build with an
-- update() API — keep parsers in sync whenever vim.pack updates the plugin.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
			require("nvim-treesitter").update()
		end
	end,
})

vim.pack.add({
	-- master is frozen; main is the maintained rewrite.
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
})

-- install() is async and skips parsers that are already present, so
-- running it on every startup is cheap. html is for leetcode.nvim's
-- question descriptions.
require("nvim-treesitter").install({
	"c",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"svelte",
	"typescript",
	"javascript",
	"html",
})

-- The main branch no longer starts highlighting for you — opt in per
-- buffer. pcall: not every filetype has a parser installed.
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype

		-- Let VimTeX handle LaTeX syntax highlighting.
		if ft == "tex" or ft == "latex" then
			return
		end

		pcall(vim.treesitter.start, args.buf)

		pcall(function()
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end)
	end,
})

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

--- To-do comments ---

vim.pack.add({
	"https://github.com/folke/todo-comments.nvim",
})

require("todo-comments").setup({
	signs = true, -- show icons in the signs column
	sign_priority = 8, -- sign priority
	-- keywords recognized as todo comments
	keywords = {
		FIX = {
			icon = " ", -- icon used for the sign, and in search results
			color = "error", -- can be a hex color, or a named color (see below)
			alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
			-- signs = false, -- configure signs for some keywords individually
		},
		TODO = { icon = " ", color = "info" },
		HACK = { icon = " ", color = "warning" },
		WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
		PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
		NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
		TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
	},
	gui_style = {
		fg = "NONE", -- The gui style to use for the fg highlight group.
		bg = "BOLD", -- The gui style to use for the bg highlight group.
	},
	merge_keywords = true, -- when true, custom keywords will be merged with the defaults
	-- highlighting of the line containing the todo comment
	-- * before: highlights before the keyword (typically comment characters)
	-- * keyword: highlights of the keyword
	-- * after: highlights after the keyword (todo text)
	highlight = {
		multiline = true, -- enable multine todo comments
		multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
		multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
		before = "", -- "fg" or "bg" or empty
		keyword = "bg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
		after = "fg", -- "fg" or "bg" or empty
		pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
		comments_only = true, -- uses treesitter to match keywords in comments only
		max_line_len = 400, -- ignore lines longer than this
		exclude = {}, -- list of file types to exclude highlighting
	},
	-- list of named colors where we try to extract the guifg from the
	-- list of highlight groups or use the hex color if hl not found as a fallback
	colors = {
		error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
		warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
		info = { "DiagnosticInfo", "#2563EB" },
		hint = { "DiagnosticHint", "#10B981" },
		default = { "Identifier", "#7C3AED" },
		test = { "Identifier", "#FF00FF" },
	},
	search = {
		command = "rg",
		args = {
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
		},
		-- regex that will be used to match keywords.
		-- don't replace the (KEYWORDS) placeholder
		pattern = [[\b(KEYWORDS):]],
		-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
	},
})
