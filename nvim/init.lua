if vim.g.vscode then
  require("vscode-config")
else
  -- bootstrap lazy.nvim, LazyVim and your plugins
  require("config.lazy")
  require("config.commands")
end
