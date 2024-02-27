return {
  -- add gruvbox
  -- {
  --   "folke/tokyonight.nvim",
  --   -- opts = { style = "storm" },
  -- },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      background = { -- :h background
        light = "latte",
        dark = "frappe",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
}
