local wibox = require "wibox"
local helpers = require "helpers"
local palette = require "theme.palette"

-----------------------------
-- Clock
-----------------------------

widgets.clock = wibox.widget {
    bg = palette.detail,
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
            bg = palette.bg,
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

