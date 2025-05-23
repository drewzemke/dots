-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- Open maximized
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)


-- This table will hold the rest of the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end


-- first things first:
config.color_scheme = 'Dracula (Official)'

-- set font size and tracking
-- {{#if dotter.packages.mac}}
config.font_size = 14.0
-- {{else}}
config.font_size = 10.0
-- {{/if}}
config.cell_width = 1.0 -- this is the default; bump up to 1.1?

-- anti-aliasing config: seems better on work displays but not sure about in general
config.freetype_load_target = 'HorizontalLcd'

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

  {
    key = 'm',
    mods = 'CMD|CTRL|ALT',
    action = act.ToggleFullScreen
  },
}

config.disable_default_key_bindings = true


-- {{#if dotter.packages.linux}}
-- transparent bg 
config.window_background_opacity = 0.92
-- {{/if}}
config.macos_window_background_blur = 15

-- pump that framerate babyyy
config.max_fps = 144

-- yes I just want to quit, thank you
config.window_close_confirmation = "NeverPrompt"

-- and finally, return the configuration to wezterm
return config

