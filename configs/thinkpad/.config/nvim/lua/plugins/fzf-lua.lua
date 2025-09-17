return {
	"ibhagwan/fzf-lua",
	keys = {
		{ "<leader>p", "<cmd>FzfLua files<cr>", "n", desc = "Find File" },
		{ "<leader>P", "<cmd>FzfLua commands<cr>", "n", desc = "Command Palette" },
		{ "<leader>fb", "<cmd>FzfLua buffers<cr>", "n", desc = "Find Buffer" },
		{ "<leader>fz", "<cmd>FzfLua<cr>", "n", desc = "All FzfLua menus" },
		{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", "n", desc = "Rip Grep" },
	},
	opts = {
		grep = {
			hidden = true,
		},
	},
}
