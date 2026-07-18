vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

vim.g.mapleader = " "

-- Lazy.nvim letöltése, ha még nincs meg
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Pluginok beállítása a Lazy biztonságos módszerével
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- A 'main' megmondja a Lazy-nak, hogy melyik modult töltse be
    main = "nvim-treesitter.configs", 
    -- Az 'opts' tartalmát pedig átadja a fenti modulnak (ez oldja meg a betöltési hibát)
    opts = {
      ensure_installed = { "c", "lua" },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
})
