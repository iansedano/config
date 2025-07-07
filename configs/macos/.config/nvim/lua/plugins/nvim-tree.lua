return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = true,
	cmd = {
		"NvimTreeOpen",
		"NvimTreeClose",
		"NvimTreeToggle",
		"NvimTreeFocus",
		"NvimTreeRefresh",
		"NvimTreeFindFile",
		"NvimTreeFindFileToggle",
		"NvimTreeClipboard",
		"NvimTreeResize",
		"NvimTreeCollapse",
		"NvimTreeCollapseKeepBuffers",
		"NvimTreeHiTest",
	},
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>b", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
	},
	opts = {
		filters = {
			dotfiles = false,
			git_ignored = false,
		},
	},
}
