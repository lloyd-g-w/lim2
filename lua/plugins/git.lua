local plugins = {
	"https://github.com/nvim-lua/plenary.nvim", -- needed by telescope (lazy.nvim pulled it in for you)
	"https://github.com/sindrets/diffview.nvim",
	"https://github.com/m00qek/baleia.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/NeogitOrg/neogit",
}

-- Install (and track for vim.pack.update) but don't put them on the runtimepath yet
vim.pack.add(plugins, { load = function() end })

local loaded = false
local function load_neogit()
	if loaded then
		return
	end
	loaded = true
	for _, src in ipairs(plugins) do
		vim.cmd.packadd(src:match("[^/]+$"))
	end
end

-- Stub command that loads Neogit on first use, then forwards the call
vim.api.nvim_create_user_command("Neogit", function(opts)
	vim.api.nvim_del_user_command("Neogit")
	load_neogit()
	vim.cmd("Neogit " .. opts.args)
end, { nargs = "*" })

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Show Neogit UI" })
