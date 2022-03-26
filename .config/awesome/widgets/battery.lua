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
-- Bluetooth
-----------------------------
bluetooth_text = ''

bluetooth_color_red_on = tonumber("0x45")
bluetooth_color_green_on = tonumber("0xb6")
bluetooth_color_blue_on = tonumber("0xfe")
bluetooth_color_red_off = tonumber("0x11")
bluetooth_color_green_off = tonumber("0x67")
bluetooth_color_blue_off = tonumber("0xb1")

bluetooth_text_widget = wibox.widget {
  font = "Iosevka 14",
  widget = wibox.widget.textbox,
  markup = "<span foreground='#0000" .. "'>" .. bluetooth_text .. "</span>",
}

local color_mix = function(on, off, d) 
    return string.format("%x", math.floor(off + (on - off) * d))
end

bluetooth_color = rubato.timed {
    duration = 0.5,
    subscribed = function(v) 
      bluetooth_text_widget.markup = "<span foreground='#" .. color_mix(bluetooth_color_red_on, bluetooth_color_red_off, v) .. color_mix(bluetooth_color_green_on, bluetooth_color_green_off, v) ..  color_mix(bluetooth_color_blue_on, bluetooth_color_blue_off, v) .. "'>" .. bluetooth_text .. "</span>"
    end
}

gears.timer{timeout = 1, 
    callnow = true,
    autostart = true,
    callback = function()
        awful.spawn.easy_async_with_shell("bluetoothctl devices | cut -f2 -d' ' | while read uuid; do bluetoothctl info $uuid; done|grep -e Connected | cut -d':' -f2 | cut -b2- | awesome_iconizer --mode bluetooth",
            function(stdout, stderr, exitreason, exitcode)
                bluetooth_text = stdout
                if stdout == "\n" then
                    bluetooth_color.target = 0
                else 
                    bluetooth_color.target = 1
                end
            end)
    end,
}

widgets.bluetooth = wibox.widget {
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
                    widget = bluetooth_text_widget,
                },
            }
        },
    },
}
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
-- Clock
-----------------------------

widgets.clock = wibox.widget {
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
                    widget = wibox.widget.textclock('<span color="#000000" font="Iosevka 14">%H:%M</span>')
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

-----------------------------
-- Taglist
-----------------------------

widgets.taglist_template = wibox.widget {
    bg = palette.bg,
    shape = helpers.rrect(20),
    widget = wibox.container.background,
    {
        left = 10,
        right = 13,
        top = 3,
        bottom = 3,
        widget = wibox.container.margin,
    },
}

