return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>ss",
      "<cmd>Telescope lsp_document_symbols<cr>",
      desc = "Goto Symbol",
    },
    {
      "<leader>sS",
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      desc = "Goto Symbol (Workspace)",
    },
  },
}
