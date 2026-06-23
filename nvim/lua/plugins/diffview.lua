return {
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>gdo', '<cmd>DiffviewOpen<cr>', desc = 'Open Diffview' },
    { '<leader>gdm', '<cmd>DiffviewOpen main...HEAD<cr>', desc = 'Open Diffview vs main' },
    { '<leader>gdc', '<cmd>DiffviewClose<cr>', desc = 'Close Diffview' },
    { '<leader>gdh', '<cmd>DiffviewFileHistory<cr>', desc = 'Browse commit history' },
    {
      '<leader>gdi',
      function()
        vim.ui.input({ prompt = 'Diff HEAD vs commit: ' }, function(ref)
          if ref and ref ~= '' then
            vim.cmd('DiffviewOpen ' .. ref)
          end
        end)
      end,
      desc = 'Diff HEAD vs commit (prompt)',
    },
    {
      '<leader>gdp',
      function()
        vim.ui.input({ prompt = 'Diff single commit vs its parent: ' }, function(ref)
          if ref and ref ~= '' then
            vim.cmd('DiffviewOpen ' .. ref .. '^..' .. ref)
          end
        end)
      end,
      desc = 'Diff single commit vs its parent (prompt)',
    },
  },
}
