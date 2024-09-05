return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				"css-lsp",
				"eslint-lsp",
				"html-lsp",
				"json-lsp",
				"prettier",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			inlay_hints = {
				enabled = false,
			},
		},
	},
}
