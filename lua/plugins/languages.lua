--- Latex ---

-- vimtex is plain Vimscript and reads its vim.g options when its plugin
-- files are sourced — vim.pack.add loads immediately, so these must be
-- set first (lazy.nvim's `init` served this purpose in lim).
--
-- tex_flavor forces the builtin ftdetect/tex.vim to always classify
-- .tex files as "tex" instead of "plaintex" — without it, files that
-- don't yet contain LaTeX-specific content (new files, simple ones)
-- get detected as "plaintex" and silently miss anything keyed to the
-- "tex" filetype, including the LuaSnip snippets in snippets.lua.
vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = "latexmk"
-- -shell-escape is required by packages that shell out during compilation
-- (e.g. minted, which invokes pygmentize) — off by default in vimtex
-- since it lets the document's own .tex source run arbitrary shell
-- commands, so only enable it if you trust what you're compiling.
vim.g.vimtex_compiler_latexmk = {
	aux_dir = ".build",
	options = {
		"-verbose",
		"-file-line-error",
		"-synctex=1",
		"-interaction=nonstopmode",
		"-shell-escape",
	},
}

vim.pack.add({
	"https://github.com/lervag/vimtex",
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
