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

vim.lsp.config("tinymist", {
	settings = {
		formatterMode = "typstyle",
		formatterPrintWidth = 80,
		formatterIndentSize = 2,
		formatterProseWrap = true,
	},
})

vim.lsp.config("ocamllsp", {
	settings = {
		merlinDiagnostics = { enable = true },
		extendedHover = { enable = true },
		codelens = { enable = true },
		inlayHints = { enable = true },
		syntaxDocumentation = { enable = true },
		merlinJumpCodeActions = { enable = true },
	},
})

-- Enable whichever servers you've added to extraPackages. Names must
-- match nvim-lspconfig's config names. (jdtls is wired separately in
-- languages.lua — it needs nvim-jdtls' start_or_attach, not vim.lsp.enable.)
vim.lsp.enable({
	"lua_ls",
	"nixd",
	"texlab",
	"svelte",
	"ts_ls",
	"basedpyright",
	"vimls",
	"csharp_ls",
	"cmake",
	"tinymist",
	"rust_analyzer",
	"zls",
	"qmlls",
	"hls",
	"ocamllsp",
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

vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		yaml = { "yq" },
		json = { "jq" },
		jsonc = { "prettier" },
		nix = { "alejandra" },
		tex = { "tex-fmt" },
		css = { "prettier" },
		markdown = { "markdownlint" },
		cpp = { "clang-format" },
		c = { "clang-format", "astyle" },
		ocaml = { "ocamlformat" },
	},
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { silent = true, desc = "Format buffer" })
