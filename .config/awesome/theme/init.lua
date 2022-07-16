theme = {}

local THEME = "edge"

-- Colors
local palette = require("theme." .. THEME .. ".palette")

theme.border_focus  = palette.detail
theme.border_normal  = palette.bg
theme.widget_bg = palette.bg
theme.accent = palette.detail


-- Wallpaper

local wallpaper = require("theme." .. THEME .. ".wallpaper")
theme.wallpaper = wallpaper.path

-- Misc
local dpi = require("beautiful.xresources").apply_dpi

theme.font          = "JetBrains Mono 16"
theme.useless_gap   = dpi(6)
theme.border_width  = dpi(0.5)

return theme
