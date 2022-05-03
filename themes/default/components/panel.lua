-- Panel

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi



-- ===================================================================
-- create widget
-- ===================================================================

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- taglist
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))


mytextclock = wibox.widget.textclock()


-- define module table
local panel = {}

-- ===================================================================
-- Bar Creation
-- ===================================================================

panel.create = function(s)
    local panel = awful.wibar({
        screen = s,
        position = "bottom",
        ontop = false,
        height = beautiful.top_panel_height,
        width = s.geometry.width,
    })

        

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- layoutbox
   s.mylayoutbox = awful.widget.layoutbox(s)
   s.mylayoutbox:buttons(gears.table.join(
                       awful.button({ }, 1, function () awful.layout.inc( 1) end),
                       awful.button({ }, 3, function () awful.layout.inc(-1) end),
                       awful.button({ }, 4, function () awful.layout.inc( 1) end),
                       awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    
    panel:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist
        },
            s.mytasklist,
        { -- Right
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox
        }
    }




    -- ===================================================================
    -- Functionality
    -- ===================================================================

end

return panel