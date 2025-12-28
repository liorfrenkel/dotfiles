vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.scrolloff = 8

vim.opt.wrap = false

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.backspace = 'indent,eol,start'
vim.opt.clipboard:append 'unnamedplus'

vim.keymap.set('n', '<leader>ef', function()
  vim.fn.VSCodeNotify 'workbench.files.action.showActiveFileInExplorer'
end)
