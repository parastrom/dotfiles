local colors = {
  fg               = "#D7D7D7",
  bg               = "#1B1D26",
  comment          = "#5E6173",
  cursor_fg        = "#D7D7D7",
  cursor_bg        = "#AEAFAD",
  accent           = "#BBBBBB",
  line_fg          = "#555B6C",
  line_bg          = "#1B1D26",
  gutter_bg        = "#1B1D26",
  non_text         = "#606978",
  selection_bg     = "#5E697E",
  selection_fg     = "#495163",
  vsplit_fg        = "#cccccc",
  vsplit_bg        = "#21252D",
  visual_select_bg = "#272932",
  red              = "#D95555",
  green            = "#76C5A4",
  blue             = "#8DBBD3",
  gray             = "#21252D",
  orange           = "#E0828D",
  yellow           = "#E3CF65",
}

return {
  normal = {
    a = { bg = colors.accent, fg = colors.bg, gui = "bold" },
    b = { bg = colors.selection_bg, fg = colors.fg },
    c = { bg = colors.gray, fg = colors.comment },
  },
  insert = {
    a = { bg = colors.green, fg = colors.bg, gui = "bold" },
    b = { bg = colors.selection_bg, fg = colors.fg },
    c = { bg = colors.selection_bg, fg = colors.fg },
  },
  visual = {
    a = { bg = colors.orange, fg = colors.bg, gui = "bold" },
    b = { bg = colors.selection_bg, fg = colors.fg },
    c = { bg = colors.visual_select_bg, fg = colors.comment },
  },
  replace = {
    a = { bg = colors.red, fg = colors.bg, gui = "bold" },
    b = { bg = colors.selection_bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
  command = {
    a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
    b = { bg = colors.selection_bg, fg = colors.fg },
    c = { bg = colors.visual_select_bg, fg = colors.comment },
  },
  inactive = {
    a = { bg = colors.gray, fg = colors.comment, gui = "bold" },
    b = { bg = colors.gray, fg = colors.comment },
    c = { bg = colors.gray, fg = colors.comment },
  },
}
