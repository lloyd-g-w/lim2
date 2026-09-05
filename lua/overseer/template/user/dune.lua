local function has_dune_project()
	return vim.fs.find("dune-project", { upward = true, path = vim.fn.getcwd() })[1] ~= nil
end

local function task(name, args, extra)
	return {
		name = name,
		builder = function()
			return vim.tbl_extend("force", {
				cmd = { "dune" },
				args = args,
				components = {
					{ "on_output_quickfix", errorformat = "%f:%l:%c-%*[0-9]:%m,%f:%l:%c:%m", open_on_exit = "failure" },
					"default",
				},
			}, extra or {})
		end,
		condition = { callback = has_dune_project },
	}
end

return {
	task("dune build", { "build", "@all" }),
	task("dune watch", { "build", "@all", "--watch", "--display", "quiet" }),
	task("dune test", { "test" }),
	task("dune exec", { "exec", "--", "./bin/main.exe" }),
}
