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

-- set font size and tracking
config.font_size = 10.0
config.cell_width = 1.0 -- this is the default; bump up to 1.1?

-- hide the tab bar
config.hide_tab_bar_if_only_one_tab = true

-- hide the window title bar
config.window_decorations = 'RESIZE'

-- keybindings
local act = wezterm.action
config.keys = {

  -- zellij pane movement rebindings
  {
    key = 'h',
    mods = 'CMD|CTRL',
    action = act.SendKey { key = 'α' }
  },
  {
    key = 'j',
    mods = 'CMD|CTRL',
    action = act.SendKey { key = 'β' }
  },
  {
    key = 'k',
    mods = 'CMD|CTRL',
    action = act.SendKey { key = 'γ' }
  },
  {
    key = 'l',
    mods = 'CMD|CTRL',
    action = act.SendKey { key = 'δ' }
  },
  {
    key = '\'',
    mods = 'CMD|CTRL',
    action = act.SendKey { key = 'ϵ' }
  },

  {
    key = 'v',
    mods = 'CMD',
    action = act.PasteFrom 'Clipboard'
  },
  {
    key = '-',
    mods = 'CMD',
    action = act.DecreaseFontSize
  },
  {
    key = '=',
    mods = 'CMD',
    action = act.IncreaseFontSize
  },
}

config.disable_default_key_bindings = true


-- transparent bg 
config.window_background_opacity = 0.92
config.macos_window_background_blur = 15

-- pump that framerate babyyy
config.max_fps = 144


-- and finally, return the configuration to wezterm
return config

