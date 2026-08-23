--- Latex ---
vim.pack.add({
	"https://github.com/let-def/texpresso.vim",
})

--- Typst ---
vim.pack.add({
	"https://github.com/chomosuke/typst-preview.nvim",
})

--- Java ---
-- jdtls doesn't fit nvim-lspconfig's declarative model (it needs a
-- per-project workspace dir), so it's started by hand instead of going
-- through lsp.lua's vim.lsp.enable list.
vim.pack.add({
	"https://github.com/mfussenegger/nvim-jdtls",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		require("jdtls").start_or_attach({
			cmd = { "jdtls", "-data", vim.fn.stdpath("data") .. "/jdtls-workspace" },
			root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "build.gradle" }),
		})
	end,
})
