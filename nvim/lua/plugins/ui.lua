return {
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 3000,
		},
		init = function()
			local notify = require("notify")
			local filtered_notify = function(...)
				local msg, level = select(1, ...)
				if level == vim.log.levels.ERROR and string.match(msg, "vtsls: %-%d+") then
					return -- ignored
				end
				return notify(...)
			end
			vim.notify = filtered_notify
		end,
	},
	{
		"folke/noice.nvim",
    enabled = false,
		opts = {
			messages = {
				enabled = true,
			},
		},
	},
}
