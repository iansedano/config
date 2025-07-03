return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		-- { "antosha417/nvim-lsp-file-operations", config = true },
		-- { "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set key bindings

				opts.desc = "Smart rename"
				keymap.set("n", "gr", vim.lsp.buf.rename, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)
				-- set binding for go to definition
				opts.desc = "Go to definition"
				keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				-- set binding to show references
				opts.desc = "Show references"
				keymap.set("n", "gR", vim.lsp.buf.references, opts)
				-- show line diagnostics
				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
				-- trigger completion
				opts.desc = "Trigger completion"
				keymap.set("i", "<C-p>", vim.lsp.buf.completion, opts)
			end,
		})

		-- Change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
	end,
}
