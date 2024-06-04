return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	keys = {
		{
			"<leader>cp",
			function()
				require("conform").format({ timeout_ms = 3000 })
			end,
			mode = { "n", "v" },
			desc = "Format only",
		},
	},
}
