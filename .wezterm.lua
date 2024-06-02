-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = 'Ayu Dark (Gogh)'
config.font = wezterm.font 'Iosevka Nerd Font'
-- How many lines of scrollback you want to retain per tab
config.scrollback_lines = 20000

-- Scrollbar config
config.enable_scroll_bar = true
config.colors = {scrollbar_thumb = '#999999'}
config.window_padding = {
  left = 5,
  right = 15,
  top = 0,
  bottom = 0,
}

-- Temp fix, remove eventually
config.enable_wayland = false

return config
