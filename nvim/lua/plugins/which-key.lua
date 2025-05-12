return {
  {
    'folke/which-key.nvim',
    -- normal autocommands events (`:help autocmd-events`).
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        keys = {},
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>f', group = '[F]ind' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>u', group = '[U]i' },
        { '<leader>ub', group = '[B]ackground' },
        { '<leader>c', group = '[C]ode' },
        { '<leader>x', group = 'Diagnostics' },
        -- Lior: this is not working
        -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>g', group = '[G]it' },
        { '<leader>gd', group = '[G]it [D]iff' },
      },
    },
  },
}
