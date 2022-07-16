local wibox = require "wibox"
local helpers = require "helpers"
local theme = require "theme"

-----------------------------
-- Clock
-----------------------------

widgets.clock = wibox.widget {
    bg = theme.accent,
    shape = helpers.rrect(9),
    widget = wibox.container.background,
    {
        left = 4,
        right = 4,
        top = 3,
        bottom = 3,
        widget = wibox.container.margin,
        {
            widget = wibox.container.background,
            shape = helpers.rrect(9),
            bg = theme.widget_bg,
            {
                left = 7,
                right = 7,
                --top = 5,
                --bottom = 5,
                widget = wibox.container.margin,
                {
                    widget = wibox.widget.textclock('<span color="#000000" font="Iosevka 14">%H:%M</span>')
                },
            }
        },
    },
}

