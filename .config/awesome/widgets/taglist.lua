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
        cr:set_source(gears.color(palette.detail))
        gears.shape.circle(cr, width, height)
        cr:fill()
        cr:set_source(gears.color(palette.bg))
        cr:arc(width / 2, height / 2, width * 0.45, 0, 2 * math.pi)
        cr:fill()

        --------------------
        -- Draw app circle
        --------------------
        cr:set_source(gears.color(palette.detail))
        cr:arc(width / 2, height / 2, 13, 0, 2 * math.pi)
        cr:set_line_width(self.has_clients_radius);
        cr:stroke()

        --------------------
        -- Draw attention circle
        --------------------
        cr:arc(width / 2, height / 2, self.is_active_radius, 0, 2*math.pi)
        cr:fill()

        --------------------
        -- Draw hidden clients
        --------------------
        cr:set_line_width(2.5);
        cr:move_to(width / 2, height / 2)
        cr:line_to(width / 2 + 13 * self.has_hidden_clients, height / 2)
        cr:move_to(width / 2, height / 2)
        cr:line_to(width / 2 - 13 * self.has_hidden_clients, height / 2)
        cr:move_to(width / 2, height / 2)
        cr:line_to(width / 2 - 13 / 2 * self.has_hidden_clients, height / 2 - 13 * self.has_hidden_clients * math.sqrt(3) / 2)
        cr:move_to(width / 2, height / 2)
        cr:line_to(width / 2 + 13 * self.has_hidden_clients / 2, height / 2 + 13 * self.has_hidden_clients * math.sqrt(3) / 2)
        cr:move_to(width / 2, height / 2)
        cr:line_to(width / 2 + 13 * self.has_hidden_clients / 2, height / 2 - 13 * self.has_hidden_clients * math.sqrt(3) / 2)
        cr:move_to(width / 2, height / 2)
        cr:line_to(width / 2 - 13 * self.has_hidden_clients / 2, height / 2 + 13 * self.has_hidden_clients * math.sqrt(3) / 2)
        cr:stroke()
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
                    duration = 0.2,
                    intro = 0,
                    pos = 0,
                    subscribed = function(v)
                        self.has_clients_radius = v
                        self:emit_signal("widget::redraw_needed")
                    end,
                }
                self.has_hidden_clients_timed = rubato.timed {
                    duration = 0.2,
                    intro = 0,
                    pos = 0,
                    subscribed = function(v)
                        self.has_hidden_clients = v
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
                    self.has_clients_circle.target = 5
                else 
                    self.has_clients_circle.target = 0
                end
                if helpers.tag_has_minimized_clients(c3:clients()) then
                    self.has_hidden_clients_timed.target = 1
                else
                    self.has_hidden_clients_timed.target = 0
                end
            end,
        },
        layout = {
            spacing = 7,
            layout  = wibox.layout.fixed.horizontal
        },
    }
end
