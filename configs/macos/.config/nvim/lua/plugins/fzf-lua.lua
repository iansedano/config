return {
	"ibhagwan/fzf-lua",
	keys = {
		{ "<leader>p", ":FzfLua files<CR>", "n", desc = "Find File" },
		{ "<leader>P", ":FzfLua commands<CR>", "n", desc = "Command Palette" },
		{ "<leader>fb", ":FzfLua buffers<CR>", "n", desc = "Find Buffer" },
		{ "<leader>fz", ":FzfLua<CR>", "n", desc = "All FzfLua menus" },
		{ "<leader>fg", ":FzfLua live_grep<CR>", "n", desc = "Rip Grep" },
	},
	opts = {
		grep = {
			rg_opts = "--column --line-number --no-heading --color=always --hidden --smart-case --max-columns=4096 -e",
		},
	},
}
