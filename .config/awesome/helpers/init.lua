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

function helpers.table_length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

return helpers
