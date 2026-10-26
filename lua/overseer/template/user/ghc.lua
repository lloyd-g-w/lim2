-- Single-file Haskell tasks using plain ghc, for code that isn't in a
-- cabal/stack project (haskell.lua covers those). ghc itself isn't in
-- extraPackages: whatever ghc is on PATH (course env, nix shell, ...) is
-- used, so it always matches the hls/ghc version the project expects.

local function task(name, cmd, args, cwd)
	return {
		name = name,
		builder = function()
			return {
				cmd = { cmd },
				args = args,
				cwd = cwd,
				components = {
					"default",
				},
			}
		end,
	}
end

return {
	condition = {
		filetype = { "haskell" },
	},
	generator = function()
		local file = vim.api.nvim_buf_get_name(0)
		if file == "" then
			return "Current buffer has no file"
		end

		local dir = vim.fs.dirname(file)
		local name = vim.fn.fnamemodify(file, ":t")
		local stem = vim.fn.fnamemodify(file, ":t:r")

		return {
			-- Everything ghc writes (.o, .hi, the executable) goes in build/ so
			-- the source dir stays clean. ghc creates -outputdir itself but
			-- refuses an -o whose directory doesn't exist yet, so mkdir it first
			-- (in the command, not the builder, so restarts survive rm -r build).
			task("ghc build " .. name, "sh", {
				"-c",
				'mkdir -p build && exec ghc -outputdir build -o "build/$1" "$2"',
				"sh",
				stem,
				name,
			}, dir),
			-- runghc interprets main directly, so no build step is needed first.
			task("ghc run " .. name, "runghc", { name }, dir),
			task("Haskell: REPL current file", "ghci", { name }, dir),
		}
	end,
}
