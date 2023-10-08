-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end


-- first things first:
config.color_scheme = 'Dracula'

-- hide the tab bar
config.hide_tab_bar_if_only_one_tab = true

-- hide the window title bar
config.window_decorations = "RESIZE"

-- and finally, return the configuration to wezterm
return config

