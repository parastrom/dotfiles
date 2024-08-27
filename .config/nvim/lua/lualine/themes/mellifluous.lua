local M = require("mellifluous.colors")

local function get_colors(style)
  local bg = style == "light" and M.get_bg_light() or M.get_bg_dark()
  local colors = style == "light" and M.get_colors_light(bg) or M.get_colors_dark(bg)
  return colors
end

local function create_theme(style)
  local colors = get_colors(style)
  local config = require("mellifluous.config").config
  local mellifluous_config = config.mellifluous
  local bg1 = mellifluous_config.transparent_background and colors.bg or colors.bg:lighten(5)

  -- Enhance git colors for better visibility
  local git_add = colors.green:saturate(50):lighten(20)
  local git_change = colors.blue:saturate(50):lighten(20)
  local git_delete = colors.red:saturate(50):lighten(20)

  return {
    normal = {
      a = { bg = colors.blue.hex, fg = colors.bg.hex, gui = 'bold' },
      b = { bg = bg1:darken(10).hex, fg = colors.fg:lighten(30).hex },
      c = { bg = bg1.hex, fg = colors.fg:lighten(10).hex }
    },
    insert = {
      a = { bg = colors.green.hex, fg = colors.bg.hex, gui = 'bold' },
      b = { bg = bg1:darken(10).hex, fg = colors.fg:lighten(30).hex },
      c = { bg = bg1.hex, fg = colors.fg:lighten(10).hex }
    },
    visual = {
      a = { bg = colors.purple.hex, fg = colors.bg.hex, gui = 'bold' },
      b = { bg = bg1:darken(10).hex, fg = colors.fg:lighten(30).hex },
      c = { bg = bg1.hex, fg = colors.fg:lighten(10).hex }
    },
    replace = {
      a = { bg = colors.red.hex, fg = colors.bg.hex, gui = 'bold' },
      b = { bg = bg1:darken(10).hex, fg = colors.fg:lighten(30).hex },
      c = { bg = bg1.hex, fg = colors.fg:lighten(10).hex }
    },
    command = {
      a = { bg = colors.yellow.hex, fg = colors.bg.hex, gui = 'bold' },
      b = { bg = bg1:darken(10).hex, fg = colors.fg:lighten(30).hex },
      c = { bg = bg1.hex, fg = colors.fg:lighten(10).hex }
    },
    inactive = {
      a = { bg = bg1.hex, fg = colors.fg:darken(20).hex },
      b = { bg = bg1.hex, fg = colors.fg:darken(20).hex },
      c = { bg = bg1.hex, fg = colors.fg:darken(20).hex }
    },
    -- Git signs with enhanced visibility
    diff = {
      add = { fg = git_add.hex, bg = bg1.hex },
      change = { fg = git_change.hex, bg = bg1.hex },
      delete = { fg = git_delete.hex, bg = bg1.hex },
    }
  }
end

return {
  dark = create_theme("dark"),
  light = create_theme("light")
}
