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
