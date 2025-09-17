return {
	"andrewferrier/wrapping.nvim",
	config = function()
		require("wrapping").setup({
			-- Auto-detect wrapping mode for text-like files
			auto_set_mode_heuristically = true,
			
			-- File types to auto-detect wrapping for
			auto_set_mode_filetype_allowlist = {
				"asciidoc",
				"gitcommit", 
				"latex",
				"mail",
				"markdown",
				"rst",
				"tex",
				"text",
			},
			
			-- Show notification when switching modes
			notify_on_switch = true,
			
			-- Create default commands (HardWrapMode, SoftWrapMode, ToggleWrapMode)
			create_commands = true,
			
			-- Create default keymappings ([ow, ]ow, yow)
			create_keymaps = true,
		})
	end,
	-- Load when opening text-like files or when commands are used
	ft = { "markdown", "text", "asciidoc", "latex", "tex", "rst", "gitcommit", "mail" },
	cmd = { "HardWrapMode", "SoftWrapMode", "ToggleWrapMode", "WrappingOpenLog" },
	keys = {
		{ "[ow", desc = "Enable soft wrap mode" },
		{ "]ow", desc = "Enable hard wrap mode" },
		{ "yow", desc = "Toggle wrap mode" },
	},
}
