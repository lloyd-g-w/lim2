-- A string log level sidesteps an avante startup bug: its log module builds the
-- numeric reverse-lookup by inserting into a table while pairs()-iterating it
-- (undefined behavior), which intermittently drops entries and makes the default
-- numeric WARN level fail an assert. The string path only uses original keys.
vim.g.avante = { log_level = "warn" }

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "avante.nvim" and (kind == "install" or kind == "update") then
			-- Use `./build.sh` to use prebuilt libraries
			vim.system({ "make" }, { cwd = ev.data.path }):wait()
		end
	end,
})

vim.pack.add({
	{
		src = "https://github.com/yetone/avante.nvim",
		version = "main", -- default
	},

	-- Deps
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",

	-- Optional deps
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/nvim-tree/nvim-web-devicons", -- or 'echasnovski/mini.icons'
	"https://github.com/HakonHarnes/img-clip.nvim",
	"https://github.com/zbirenbaum/copilot.lua",
	"https://github.com/folke/snacks.nvim", -- for modern input UI
})

require("avante").setup({})

--- Copilot ---

-- copilot.lua does nothing until setup() is called, and ghost text only
-- appears as you type with auto_trigger — by default suggestions wait for a
-- manual <M-]> / <M-[> cycle. Accept is <M-l> (Tab belongs to blink.cmp).
require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
	},
})

-- copilot.lua has no `enabled` config option and setup() always enables.
-- Tearing down immediately keeps it off (no server spawned) until
-- :Copilot enable is run, which restores the full merged config above.
require("copilot.command").disable()

vim.keymap.set("i", "<C-g>", function()
	require("copilot.suggestion").accept()
end, { desc = "Accept copilot suggestion", silent = true })
