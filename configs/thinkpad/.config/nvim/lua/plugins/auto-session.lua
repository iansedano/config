return {
	"rmagatti/auto-session",
	lazy = false,
	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "~/dev", "~/Dropbox", "/" },
		-- log_level = 'debug',
		no_restore_cmds = {
			function()
				require("nvim-tree.api").tree.open()
			end,
		},
	},
}
