return {
  -- {
  --   "rose-pine/neovim",
  --   config = function()
  --     require("rose-pine").setup({
  --       variant = "main",
  --       dark_variant = "main",
  --       bold_vert_split = false,
  --       disable_nc_background = false,
  --       disable_float_background = false,
  --       disable_italics = false,
  --
  --
  --       ---@usage string ehx value or named colour from rosepinetheme.com/palette
  --       groups = {
  --         background = "base",
  --         background_nc = "_experimental_nc",
  --         panel = "surface",
  --         panel_nc = "base",
  --         border = "highlight_med",
  --         comment = "muted",
  --         link = "iris",
  --         punctuation = "subtle",
  --
  --         error = "love",
  --         hint = "iris",
  --         info = "foam",
  --         warn = "gold",
  --
  --         headings = "subtle",
  --       },
  --
  --       highlight_groups = {
  --         ColorColumn = { bg = "rose" },
  --
  --         CursorLine = { bg = "foam", blend = 10 },
  --         StatusLine = { fg = "love", bg = "love", blend = 10 },
  --
  --         Search = { bg = "gold" }
  --       }
  --     })
  --
  --     vim.cmd("colorscheme rose-pine")
  --   end,
  -- }
  {
    "Yazeed1s/oh-lucy.nvim",
    config = function()
      vim.cmd("colorscheme oh-lucy")
    end
  }
}
