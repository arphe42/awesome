-- default theme

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local default = {}

-- ===================================================================
-- default setup
-- ===================================================================

default.initialize = function()
    -- Import panels
    local panel = require("themes.default.components.panel")

    -- Set up each screen (add tags & panels)
    awful.screen.connect_for_each_screen(function(s)
        -- Each screen has its own tag table.
        for i = 1, 9, 1
        do
            awful.tag.add(i, {
                layout = awful.layout.suit.floating,
                screen = s,
                selected = i == 1
            })
        end

        -- Add the top panel to every screen
        panel.create(s)
    end)
end

return default