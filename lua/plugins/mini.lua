vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

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

-- Override mini-pairs for ocaml
vim.api.nvim_create_autocmd("FileType", {
	pattern = "ocaml",
	callback = function(args)
		vim.keymap.set("i", "'", "'", { buffer = args.buf })
		vim.keymap.set("i", "`", "`", { buffer = args.buf })
	end,
})
