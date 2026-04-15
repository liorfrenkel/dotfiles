return {
  {
    'romus204/tree-sitter-manager.nvim',
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
      require('tree-sitter-manager').setup {
        -- Default Options
        ensure_installed = { 'typescript', 'tsx', 'javascript', 'json', 'lua' },
        -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
        -- auto_install = false, -- if enabled, install missing parsers when editing a new file
        -- highlight = true, -- treesitter highlighting is enabled by default
        -- languages = {}, -- override or add new parser sources
        -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
        -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true,
      max_lines = 0,
      trim_scope = 'outer',
      min_window_height = 0,
      multiline_threshold = 20,
      mode = 'cursor',
      separator = nil,
      zindex = 20,
    },
  },
}
