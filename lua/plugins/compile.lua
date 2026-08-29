vim.pack.add({
	"https://github.com/stevearc/overseer.nvim",
})

local overseer = require("overseer")
local last_task

overseer.setup({})

vim.keymap.set("c", "!", function()
	if vim.fn.getcmdtype() == ":" and vim.fn.getcmdline() == "" then
		return "OverseerShell "
	end
	return "!"
end, { expr = true })

vim.keymap.set("n", "<leader>oo", function()
	local was_open = require("overseer.window").is_open()

	overseer.toggle({
		enter = false,
		direction = "bottom",
	})

	-- Overseer's bottom layout puts the task list on the left and output on the
	-- right. Swap the two so moving down from an editor enters the output first.
	if not was_open then
		local task_list_win = require("overseer.window").get_win_id()
		if task_list_win then
			vim.api.nvim_win_call(task_list_win, function()
				vim.cmd("wincmd x")
			end)
		end
	end
end, { silent = true, desc = "Toggle Overseer" })

-- Choosing / running tasks

local function choose_task()
	overseer.run_task({}, function(task)
		if task then
			last_task = task
		end
	end)
end

vim.keymap.set("n", "<leader>or", function()
	if last_task then
		last_task:restart()
	else
		choose_task()
	end
end, { desc = "Run last Overseer task" })

vim.keymap.set("n", "<leader>oR", function()
	choose_task()
end, { desc = "Choose Overseer task" })
