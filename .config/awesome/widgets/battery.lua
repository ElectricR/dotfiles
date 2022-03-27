local awful = require "awful"
local wibox = require "wibox"
local beautiful = require "beautiful"
local helpers = require "helpers"
local palette = require "theme.palette"
local rubato = require "rubato"
local math = require "math"
local string = require "string"
local gears = require "gears"

-----------------------------
-- Battery
-----------------------------

widgets.battery = wibox.widget {
    bg = palette.bg,
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
            bg = "#FFFFFF",
            {
                left = 7,
                right = 7,
                --top = 5,
                --bottom = 5,
                widget = wibox.container.margin,
                {
                    widget = awful.widget.watch("sh -c \"cat /sys/class/power_supply/BAT0/capacity | awesome_iconizer --mode battery\"", 
                    30, 
                    function(widget, stdout, stderr, exitreason, exitcode)
                      widget.markup = "<span foreground='" .. palette.green .. "'>" .. stdout .. "</span>"
                      widget.font = "Iosevka 14"
                    end),
                },
            }
        },
    },
}

-----------------------------
-- Systray
-----------------------------

widgets.systray = wibox.widget {
    bg = palette.bg,
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
            bg = "#FFFFFF",
            {
                left = 7,
                right = 7,
                top = 5,
                bottom = 5,
                widget = wibox.container.margin,
                {
                    widget = wibox.widget.systray(),
                },
            }
        },
    },
}
