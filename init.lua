vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true -- show line numbers
opt.relativenumber = true -- relative line numbers
opt.cursorline = true -- highlight the current line
opt.expandtab = true -- spaces instead of tabs
opt.shiftwidth = 4 -- size of an indent
opt.tabstop = 4 -- number of spaces a tab counts for
opt.softtabstop = 4 -- spaces inserted/removed per <Tab>/<BS>
opt.smartindent = true -- smart autoindenting
opt.wrap = false -- no line wrapping
opt.ignorecase = true -- case-insensitive searching...
opt.smartcase = true -- ...unless the query has capitals
opt.hlsearch = false -- don't keep matches highlighted after a search
opt.termguicolors = true -- 24-bit colours
opt.signcolumn = "yes" -- always show the sign column
opt.clipboard = "unnamedplus" -- use the system clipboard
opt.mouse = "a" -- enable the mouse
opt.undofile = true -- persistent undo
opt.scrolloff = 8 -- keep some context around the cursor
opt.exrc = true -- allow project-local .nvim.lua files
opt.secure = true -- ...but sandbox what they can do

-- Clear an annoying default keybind (join-lines-with-comment-leader).
vim.keymap.set("n", "<S-j>", "<Nop>")

-- Exit terminal mode without a plugin.
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

-- Quickfix list navigation.
vim.keymap.set("n", "<leader>co", "<cmd>copen<cr>", { silent = true, desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>cc", "<cmd>cclose<cr>", { silent = true, desc = "Close quickfix list" })
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<cr>", { silent = true, desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<cr>", { silent = true, desc = "Previous quickfix item" })

-- Diagnostics (built into Neovim's LSP client, no plugin required).
vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, { silent = true, desc = "Open diagnostic" })
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { silent = true, desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { silent = true, desc = "Previous diagnostic" })

require("plugins.lsp")
