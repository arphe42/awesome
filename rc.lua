-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- {{{ Error handling
    -- Check if awesome encountered an error during startup and fell back to
    -- another config (This code will only ever execute for the fallback config)
    if awesome.startup_errors then
        naughty.notify({ preset = naughty.config.presets.critical,
                        title = "Oops, there were errors during startup!",
                        text = awesome.startup_errors })
    end

    -- Handle runtime errors after startup
    do
        local in_error = false
        awesome.connect_signal("debug::error", function (err)
            -- Make sure we don't go into an endless error loop
            if in_error then return end
            in_error = true

            naughty.notify({ preset = naughty.config.presets.critical,
                            title = "Oops, an error happened!",
                            text = tostring(err) })
            in_error = false
        end)
    end
-- }}}

-- ===================================================================
-- User Configuration
-- ===================================================================

local themes = {
    "default"     --1
}

-- change this number to use the corresponding theme
local theme = themes[1]
local theme_config_dir = gears.filesystem.get_configuration_dir() .. "/themes/" .. theme .. "/configuration/"

-- define default apps (global variable so other components can access it)
apps = {
    network_manager = "networkmanager",
    terminal = "alacritty",
    launcher = "dmenu_run", --"rofi -modi drun -show drun -theme " .. theme_config_dir .. "rofi.rasi",
    --screenshot = "scrot -e 'mv $f ~/Pictures/ 2>/dev/null'",
    filebrowser = "nautilus",
    browser = "firefox"
}

-- List of apps to run on start-up
local run_on_start_up = {
    "lxsession",
    "nitrogen --restore",
    --"picom --config " .. theme_config_dir .. "picom.conf"
}

-- ===================================================================
-- Initialization
-- ===================================================================

-- Run all the apps listed in run_on_start_up
for _, app in ipairs(run_on_start_up) do
    local findme = app
    local firstspace = app:find(" ")
    if firstspace then
        findme = app:sub(0, firstspace - 1)
    end
    -- pipe commands to bash to allow command to be shell agnostic
    awful.spawn.with_shell(string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app), false)
end

-- Import notification appearance
require("general.notifications")

-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. theme .. "/" .. theme .. "-theme.lua")

-- Initialize theme
local selected_theme = require("themes/" .. theme .. "/" .. theme)
selected_theme.initialize()

-- Define layouts
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.max,
}

-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- ===================================================================
-- Client Focusing
-- ===================================================================

-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")


-- Focus clients under mouse
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
 end)

 -- ===================================================================
-- Screen Change Functions (ie multi monitor)
-- ===================================================================

-- Reload config when screen geometry changes
screen.connect_signal("property::geometry", awesome.restart)

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================


collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)