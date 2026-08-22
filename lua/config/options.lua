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

-- Experimental redesign of the core messages/cmdline UI. See :h ui2.
require("vim._core.ui2").enable()
