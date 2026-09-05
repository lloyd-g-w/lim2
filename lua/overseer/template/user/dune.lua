local function find_dune_project(dir)
	return vim.fs.find("dune-project", { upward = true, type = "file", path = dir })[1]
end

local function task(name, args, cwd, extra)
	return {
		name = name,
		builder = function()
			return vim.tbl_extend("force", {
				cmd = { "dune" },
				args = args,
				cwd = cwd,
				components = {
					{ "on_output_quickfix", errorformat = "%f:%l:%c-%*[0-9]:%m,%f:%l:%c:%m", open_on_exit = "failure" },
					"default",
				},
			}, extra or {})
		end,
	}
end

return {
	cache_key = function(opts)
		return find_dune_project(opts.dir)
	end,
	generator = function(opts)
		local dune_project = find_dune_project(opts.dir)
		if not dune_project then
			return "No dune-project file found"
		end

		local cwd = vim.fs.dirname(dune_project)
		return {
			task("dune build", { "build", "@all" }, cwd),
			task("dune watch", { "build", "@all", "--watch", "--display", "quiet" }, cwd),
			task("dune test", { "test" }, cwd),
			task("dune exec", { "exec", "--", "./bin/main.exe" }, cwd),
		}
	end,
}
