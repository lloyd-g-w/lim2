vim.pack.add({
	"https://github.com/stevearc/overseer.nvim",
})

local overseer = require("overseer")
local task_slots = {}

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

local function choose_task(slot)
	overseer.run_task({}, function(task)
		if task then
			task_slots[slot] = task
		end
	end)
end

local task_slot_keys = {
	{ "1", "!" },
	{ "2", "@" },
	{ "3", "#" },
	{ "4", "$" },
	{ "5", "%" },
}

for _, keys in ipairs(task_slot_keys) do
	local slot, choose_key = unpack(keys)

	vim.keymap.set("n", "<leader>o" .. slot, function()
		if task_slots[slot] then
			task_slots[slot]:restart()
		else
			choose_task(slot)
		end
	end, { desc = "Run Overseer task in slot " .. slot })

	vim.keymap.set("n", "<leader>o" .. choose_key, function()
		choose_task(slot)
	end, { desc = "Choose Overseer task for slot " .. slot })
end
