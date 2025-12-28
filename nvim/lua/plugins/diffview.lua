return {
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>gdo', '<cmd>DiffviewOpen<cr>', desc = 'Open Diffview' },
    { '<leader>gdm', '<cmd>DiffviewOpen main<cr>', desc = 'Open Diffview vs main' },
    { '<leader>gdc', '<cmd>DiffviewClose<cr>', desc = 'Close Diffview' },
  },
}
