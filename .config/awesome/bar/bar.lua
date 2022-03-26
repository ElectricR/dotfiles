local awful = require("awful")
local widgets = require "widgets"
local wibox = require("wibox")

bar.create = function(screen)
    bar = awful.wibar({ 
        position = "top", 
        screen = screen, 
        bg = "#0000000", 
        border_width = 10,
        height = 42,
    })

    -- bar:setup({
    --     layout = wibox.layout.align.horizontal,
    --     widgets.battery,
    --     widgets.battery,
    --     widgets.battery,
    -- })

    return bar
end
