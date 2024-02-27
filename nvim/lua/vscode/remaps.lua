vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- local opts = {
--   remap = true,
-- }
vim.keymap.set("n", "<leader>ef", function() vim.fn.VSCodeNotify('workbench.files.action.showActiveFileInExplorer') end)
