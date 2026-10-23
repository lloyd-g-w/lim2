return {
	name = "Haskell: REPL current file",

	builder = function()
		local file = vim.api.nvim_buf_get_name(0)

		return {
			cmd = { "ghci" },
			args = { file },
			cwd = vim.fs.dirname(file),

			components = {
				"default",
			},
		}
	end,

	condition = {
		filetype = { "haskell" },
	},
}
