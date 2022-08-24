vim.g.mapleader = ' ' -- Set leader key
vim.o.termguicolors = true -- Enable 24-bit colors

vim.opt.laststatus = 0 -- Remove status line

vim.opt.expandtab = true -- Place spaces instead of tabs
vim.opt.shiftwidth = 4 -- Number of spaces to place
vim.opt.tabstop = 4 -- Number of characters tab will be showed as
vim.opt.smarttab = true 
vim.opt.cmdheight = 2 

vim.opt.scrolloff = 8 -- Top/bottom scroll offset

vim.opt.number = true
vim.opt.relativenumber = true


vim.o.clipboard = "unnamed" -- Use '*' register for clipboard to making it possible to share clipboard between neovim instances