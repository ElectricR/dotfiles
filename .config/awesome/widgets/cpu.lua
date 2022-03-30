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
-- CPU widget
-----------------------------

cpu_load_actual = 0

widgets.cpu_arc = wibox.widget.base.make_widget()

function widgets.cpu_arc:fit(context, width, height)
    return height, height
end

function widgets.cpu_arc:draw(context, cr, width, height)
    --------------------
    -- Draw outer circle
    --------------------
    cr:set_source(gears.color(palette.cpu))
    gears.shape.arc(cr, height, height, 4, 0.5 * math.pi, (0.5 + 2 * cpu_load_actual) * math.pi, true, true)
    cr:fill()
end

cpu_load = rubato.timed {
    duration = 0.5,
    pos = 0,
    subscribed = function(v) 
        cpu_load_actual = v
        widgets.cpu_arc:emit_signal("widget::redraw_needed")
    end
}

widgets.cpu = wibox.widget {
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
                left = 8,
                right = 4,
                top = 4,
                bottom = 4,
                widget = wibox.container.margin,
                {
                    widget = wibox.layout.stack,
                    {
                        widget = widgets.cpu_arc,
                    },
                    {   
                        widget = awful.widget.watch("awesome_iconizer --mode cpu", 
                        1, 
                        function(widget, stdout, stderr, exitreason, exitcode)
                            cpu_load.target = tonumber(stdout)
                        end),
                    },
                    {
                        widget = wibox.layout.manual,
                        forced_width = 32,
                        {
                            widget = wibox.widget.textbox,
                            point  = {x=7.6,y=5.1},
                            font = "JetBrains Mono 12",
                            markup = "<span foreground='" .. tostring(palette.cpu) .. "'></span>",
                        },
                    },
                },
            }
        },
    },
}
