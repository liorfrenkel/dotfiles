-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>ubd", "<cmd>set background=dark<cr>")
vim.keymap.set("n", "<leader>ubl", "<cmd>set background=light<cr>")
vim.keymap.set("n", "<leader>gdd", "<cmd>DiffviewOpen<cr>")
vim.keymap.set("n", "<leader>gdc", "<cmd>DiffviewClose<cr>")
vim.keymap.set("n", "<leader>ctr", "<cmd>TSToolsRenameFile<cr>", { desc = "typescript rename file" })
vim.keymap.set("n", "<leader>cto", "<cmd>TSToolsOrganizeImports<cr>", { desc = "typescript organize imports" })
vim.keymap.set("n", "<leader>cta", "<cmd>TSToolsAddMissingImports<cr>", { desc = "typescript add missing imports" })

function ToggleTestOnly()
	local line = vim.api.nvim_get_current_line() -- Get current line
	if line:match("%.only") then
		-- If the line contains '.only', remove it
		line = line:gsub("%.only", "")
	else
		-- Otherwise, insert '.only' after 'it' or 'test' or 'describe'
		line = line:gsub("^(%s*it)", "%1.only")
		line = line:gsub("^(%s*test)", "%1.only")
		line = line:gsub("^(%s*describe)", "%1.only")
	end
	vim.api.nvim_set_current_line(line) -- Set the modified line
end

function ToggleBoolean()
	local line = vim.api.nvim_get_current_line() -- Get current line
	if line:match("false") then
		line = line:gsub("false", "true", 1)
	elseif line:match("true") then
		line = line:gsub("true", "false", 1)
	end
	vim.api.nvim_set_current_line(line) -- Set the modified line
end

vim.keymap.set("n", "<leader>to", ":lua ToggleTestOnly()<CR>", { desc = "toggle .only in test" })
vim.keymap.set("n", "<leader>tb", ":lua ToggleBoolean()<CR>", { desc = "toggle next boolean" })
