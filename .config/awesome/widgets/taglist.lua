local awful = require "awful"
local wibox = require "wibox"
local helpers = require "helpers"
local palette = require "theme.palette"
local gears = require "gears"
local math = require "math"
local rubato = require "rubato"

-----------------------------
-- Taglist template
-----------------------------

widgets.taglist_template = wibox.widget.base.make_widget()

function widgets.taglist_template:fit(context, width, height)
    return height, height
end

function widgets.wrapper() 
    return function (self, context, cr, width, height)
        --------------------
        -- Draw outer circle
        --------------------
        cr:set_source(gears.color(palette.bg))
        gears.shape.circle(cr, width, height)
        cr:fill()
        cr:set_source(gears.color("#FFFFFF"))
        cr:arc(width / 2, height / 2, width * 0.45, 0, 2 * math.pi)
        cr:fill()

        --------------------
        -- Draw app circle
        --------------------
        cr:set_source(gears.color(palette.bg))
        cr:arc(width / 2, height / 2, 13, -1.5*math.pi, self.has_clients_radius*math.pi)
        cr:set_line_width(5);
        cr:stroke()

        --------------------
        -- Draw attention circle
        --------------------
        cr:arc(width / 2, height / 2, self.is_active_radius, 0, 2*math.pi)
        cr:fill()
    end
end

-----------------------------
-- Taglist
-----------------------------

function widgets.create_taglist(s, taglist_buttons)
    return awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                widget = widgets.taglist_template,
            },
            widget = wibox.container.background,
            create_callback = function(self, c3, index, objects)
                self.draw = widgets.wrapper() -- IDK why this works
                self.selected_circle = rubato.timed {
                    duration = 0.2,
                    intro = 0,
                    pos = 0,
                    subscribed = function(v)
                        self.is_active_radius = v
                        self:emit_signal("widget::redraw_needed")
                    end,
                }
                self.has_clients_circle = rubato.timed {
                    duration = 0.3,
                    intro = 0,
                    pos = -1.5,
                    subscribed = function(v)
                        self.has_clients_radius = v
                        self:emit_signal("widget::redraw_needed")
                    end,
                }
            end,
            update_callback = function(self, c3, index, objects)
                if c3.selected then
                    self.selected_circle.target = 6
                else
                    self.selected_circle.target = 0
                end
                if helpers.table_length(c3:clients()) > 0 then
                    self.has_clients_circle.target = 0.5
                else 
                    self.has_clients_circle.target = -1.5
                end
            end,
        },
        layout = {
            spacing = 10,
            layout  = wibox.layout.fixed.horizontal
        },
    }

end
