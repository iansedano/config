--[[
nvim config

Author : @iansedano

With help from:
https://github.com/josean-dev/dev-environment-files
https://www.ssp.sh/brain/neovim-setup/
https://github.com/Alexis12119/nvim-config
--]]

vim.g.mapleader = " "
vim.wo.relativenumber = true
vim.hl = vim.highlight -- https://github.com/neovim/neovim/issues/31675

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/
vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "1"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 1
vim.opt.foldnestmax = 4

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.mouse = "a"
vim.opt.autoindent = true
vim.opt.title = true
vim.opt.visualbell = true
vim.opt.number = true
vim.opt.ruler = true

vim.opt.autoread = true -- detect changes in files

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set("n", "<leader>q", ":wqa<CR>", { noremap = true, silent = true })

require("config.lazy")
require("config.commands")
