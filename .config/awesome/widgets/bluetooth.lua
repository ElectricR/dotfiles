local awful = require "awful"
local wibox = require "wibox"
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
                    widget = bluetooth_text_widget,
                },
            }
        },
    },
}
