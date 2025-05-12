return {
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>gdo', '<cmd>DiffviewOpen<cr>', desc = 'Open Diffview' },
    { '<leader>gdc', '<cmd>DiffviewClose<cr>', desc = 'Close Diffview' },
  },
}
