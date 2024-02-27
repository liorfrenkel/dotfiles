return {
  {
    "echasnovski/mini.indentscope",
    opts = {
      draw = {
        delay = 10,
        animation = require("mini.indentscope").gen_animation.none(),
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 4000,
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      messages = {
        enabled = true,
      },
    },
  },
}
