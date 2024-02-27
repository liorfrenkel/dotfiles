return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "thenbe/neotest-playwright",
    },
    -- keys = {
    --   {
    --     "<leader>tl",
    --     function()
    --       require("neotest").run.run_last()
    --     end,
    --     desc = "Run Last Test",
    --   },
    --   {
    --     "<leader>tL",
    --     function()
    --       require("neotest").run.run_last({ strategy = "dap" })
    --     end,
    --     desc = "Debug Last Test",
    --   },
    --   {
    --     "<leader>tw",
    --     "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
    --     desc = "Run Watch",
    --   },
    -- },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
        "neotest-vitest",
      },
    },
  },
}
