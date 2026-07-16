-- Alap beállítások (a régi vimrc-ből)
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.number = true
vim.opt.syntax = "on"        -- syntax highlighting bekapcsolása

-- Ajánlott extra beállítások (Neovim-ben jobban működnek)
vim.opt.relativenumber = false   -- ha szeretnéd, állítsd true-ra
vim.opt.cursorline = true
vim.opt.termguicolors = true     -- jobb színek
vim.opt.signcolumn = "yes"       -- git jelek stb. oszlop

-- Leader key (később hasznos lesz pluginokhoz)
vim.g.mapleader = " "
