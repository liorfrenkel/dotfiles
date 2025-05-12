vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

if vim.g.vscode then
  require 'vscode-config'
else
  require 'config'
end
