return {
  {
    "gelguy/wilder.nvim",
    keys = {
      ":",
      "/",
      "?",
    },
    config = function()
      local wilder = require("wilder")

      -- Create highlight groups using theme colors
      local text_highlight = wilder.make_hl("WilderText", "Normal")
      local accent_highlight = wilder.make_hl("WilderAccent", "Statement")
      local border_highlight = wilder.make_hl("WilderBorder", "Comment")


      -- Enable wilder when pressing :, / or ?
      wilder.setup({ modes = { ":", "/", "?" } })

      -- Enable fuzzy matching for commands and buffers
      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.cmdline_pipeline({
            fuzzy = 1,
          }),
          wilder.vim_search_pipeline({
            fuzzy = 1,
          })
        ),
      })

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
          highlighter = wilder.basic_highlighter(),
          highlights = {
            default = text_highlight,
            border = border_highlight,
            accent = accent_highlight,
          },
          pumblend = 5,
          min_width = "100%",
          min_height = "25%",
          max_height = "25%",
          border = "rounded",
          left = { " ", wilder.popupmenu_devicons() },
          right = { " ", wilder.popupmenu_scrollbar() },
        }))
      )
    end,
  },
}
