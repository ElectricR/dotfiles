local gears = require("gears")

helpers = {}

helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

helpers.circle = function(radius)
    return function(cr, width, height)
        gears.shape.circle(cr, radius, radius)
    end
end

return helpers
