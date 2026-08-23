vim.pack.add({
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/rafamadriz/friendly-snippets",
})

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local f = ls.function_node

ls.config.setup({ enable_autosnippets = true })
require("luasnip.loaders.from_vscode").lazy_load()

local c_snippets = {
	s("cheadercomment", {
		t("// Lloyd Williams (z5599988) | Written on " .. os.date("%d/%m/%Y")),
		t({ "", "// Description: " }),
	}),
	s("bigcomment", {
		t("// " .. string.rep("=", 20) .. " "),
		i(1),
		t(" " .. string.rep("=", 20) .. " //"),
	}),
}

ls.add_snippets("c", c_snippets)
ls.add_snippets("cpp", c_snippets)
ls.add_snippets("java", { c_snippets[2] })

local function in_mathzone()
	return vim.fn.exists("*vimtex#syntax#in_mathzone") == 1 and vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

ls.add_snippets("tex", {
	s({ trig = "bf", snippetType = "autosnippet" }, {
		d(1, function()
			return sn(nil, { t(in_mathzone() and "\\mathbf " or "\\textbf ") })
		end),
	}),
	s({ trig = "bb", snippetType = "autosnippet" }, { t("\\mathbb ") }),
})

ls.add_snippets("typst", {
	s({ trig = "mk", snippetType = "autosnippet" }, {
		t("$"),
		i(1),
		t(" $"),
	}),
	s({ trig = "dm", snippetType = "autosnippet" }, {
		t({ "$", "  " }),
		i(1),
		t({ "", "  .", "$" }),
	}),
	s({ trig = "def", name = "definition", dscr = "Typst definition block" }, {
		t({ "#definition()[", "\t" }),
		i(1),
		t({ "", "]" }),
	}),
	s({ trig = "def%s+(.+)", regTrig = true, name = "definition with title" }, {
		t('#definition(title: "'),
		f(function(_, snippet)
			return snippet.captures[1]
		end),
		t({ '")[', "\t" }),
		i(1),
		t({ "", "]" }),
	}),
	s({ trig = "b([^%s]+)", regTrig = true, wordTrig = false, name = "bold word" }, {
		f(function(_, snippet)
			return "bold(" .. snippet.captures[1] .. ")"
		end),
	}),
})

vim.keymap.set("i", "<C-k>", function()
	ls.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-l>", function()
	ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-h>", function()
	ls.jump(-1)
end, { silent = true })
