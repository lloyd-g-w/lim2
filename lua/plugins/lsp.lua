-- LSP support via Neovim's native client (vim.lsp.config / vim.lsp.enable).
-- Language servers themselves come from `extraPackages` in nvim.nix, not
-- from here. nvim-lspconfig is used only for its bundled default configs
-- (cmd, filetypes, root_markers) — no .setup() calls needed.

vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
})

-- lua_ls has no built-in knowledge of Neovim's `vim` global; point it at
-- the LuaCATS annotations Neovim ships under $VIMRUNTIME/lua.
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = { vim.env.VIMRUNTIME .. "/lua" },
				checkThirdParty = false,
			},
		},
	},
})

-- Enable whichever servers you've added to extraPackages. Names must
-- match nvim-lspconfig's config names.
vim.lsp.enable({
	"lua_ls",
})

vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	severity_sort = true,
})

-- Buffer-local keymaps, set only where an LSP client actually attaches.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(args)
		local opts = { buffer = args.buf, silent = true }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto definition" }))
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto declaration" }))
		vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
		vim.keymap.set(
			"n",
			"gi",
			vim.lsp.buf.implementation,
			vim.tbl_extend("force", opts, { desc = "Goto implementation" })
		)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
		vim.keymap.set(
			{ "n", "v" },
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code action" })
		)
	end,
})


--- Formatting ---


