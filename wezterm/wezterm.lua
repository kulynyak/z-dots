local wezterm = require("wezterm")

wezterm.log_info("Config file " .. wezterm.config_file)

-- wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
-- 	local zoomed = ""
-- 	if tab.active_pane.is_zoomed then
-- 		zoomed = "[Z] "
-- 	end
-- 	local index = ""
-- 	if #tabs > 1 then
-- 		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
-- 	end

-- 	return zoomed .. index .. tab.active_pane.title
-- end)

-- wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
--   local index = tab.tab_index + 1
--   local process = tab.active_pane.foreground_process_name
--   return string.format(" %d %s ", index, process)
-- end)

-- Define your light and dark color schemes
local light_schemes = { "Catppuccin Latte" }
local dark_schemes = {
	"Pencil Dark (Gogh)",
	"Catppuccin Mocha (Gogh)",
	"MaterialDarker",
	"Catppuccin Mocha",
	"Catppuccin Macchiato",
	"Catppuccin Frappe",
}

-- Variables to keep track of the current scheme index
local light_scheme = "Catppuccin Latte"
local dark_scheme = "Pencil Dark (Gogh)"
local default_scheme = "Pencil Dark (Gogh)"
-- local default_scheme = "Oxocarbon Dark (Gogh)"

-- Function to set color scheme
function set_color_scheme(window, scheme_name)
	wezterm.log_info("Set colorscheme to '" .. scheme_name .. "'")
	local overrides = window:get_config_overrides() or {}
	-- Check if the scheme is in the light schemes list
	if table_contains(light_schemes, scheme_name) then
		overrides.cursor_fg_color = "black"
		-- Check if the scheme is in the dark schemes list
	elseif table_contains(dark_schemes, scheme_name) then
		overrides.cursor_fg_color = "white"
	end
	-- Apply the color scheme with cursor color overrides
	overrides.color_scheme = scheme_name
	window:set_config_overrides(overrides)
end

-- Helper function to check if a table contains a value
function table_contains(tbl, element)
	for _, value in pairs(tbl) do
		if value == element then
			return true
		end
	end
	return false
end

-- Function to toggle the light color scheme
function toggle_light_scheme(window)
	set_color_scheme(window, light_scheme)
end

-- Function to toggle the dark color scheme
function toggle_dark_scheme(window)
	set_color_scheme(window, dark_scheme)
end

-- Default configuration
wezterm.on("update-right-status", function(window, _pane) end)

wezterm.on("window-config-reloaded", function(window, pane)
	window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

local window_padding = 0
local act = wezterm.action
return {
	-- window_decorations = "RESIZE",
	window_frame = {
		border_left_width = "0.0px",
		border_right_width = "0.0px",
		border_bottom_height = "0.0px",
		border_top_height = "0.0px",
		border_left_color = "black",
		border_right_color = "black",
		border_bottom_color = "black",
		border_top_color = "black",
	},
	color_scheme = default_scheme,
	colors = {
		-- The color of the split lines between panes
		split = "#AABBAA",
	},
	initial_cols = 196,
	initial_rows = 85,
	-- Cursor settings
	cursor_blink_rate = 800, -- Adjust this for the blinking rate (in milliseconds)
	cursor_blink_ease_in = "Linear",
	cursor_blink_ease_out = "Linear",
	check_for_updates = true,
	adjust_window_size_when_changing_font_size = true,
	font = wezterm.font_with_fallback({
		"FiraCode Nerd Font Mono",
		"JetBrainsMono Nerd Font Mono",
		"Hack Nerd Font Mono",
		"Fira Code",
		"FiraMono Nerd Font Mono",
	}),
	font_size = 13.0,
	-- line_height = 1.00,
	line_height = 0.97,
	enable_scroll_bar = false,
	scrollback_lines = 5000,
	front_end = "OpenGL",
	cursor_thickness = "2px",
	window_background_opacity = 0.90,
	text_background_opacity = 0.90,
	window_padding = {
		left = window_padding,
		right = window_padding,
		top = window_padding,
		bottom = window_padding,
	},
	inactive_pane_hsb = {
		hue = 1.0,
		saturation = 0.95,
		brightness = 0.65,
	},
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	-- default_cursor_style = "BlinkingBlock",
	-- cursor_blink_rate = 700,
	disable_default_key_bindings = true,
	leader = { key = "a", mods = "SUPER" },
	keys = {
		{
			key = "2",
			mods = "CTRL|ALT",
			action = wezterm.action_callback(toggle_light_scheme),
		},
		{
			key = "1",
			mods = "CTRL|ALT",
			action = wezterm.action_callback(toggle_dark_scheme),
		},
		{ key = "n", mods = "SUPER", action = act.SpawnWindow },
		-- open wezterm config
		{
			key = ",",
			mods = "SUPER",
			action = act.SpawnCommandInNewTab({
				cwd = os.getenv("WEZTERM_CONFIG_DIR"),
				set_environment_variables = { TERM = "screen-256color" },
				args = { "/opt/homebrew/bin/nvim", os.getenv("WEZTERM_CONFIG_FILE") },
			}),
		},
		-- font
		{ key = "0", mods = "CTRL|SUPER", action = act.ResetFontSize },
		{ key = "=", mods = "CTRL|SUPER", action = act.IncreaseFontSize },
		{ key = "-", mods = "CTRL|SUPER", action = act.DecreaseFontSize },

		-- show tab bar navigator
		{ key = "t", mods = "SUPER|SHIFT", action = act.ShowTabNavigator },
		-- enter debug console
		{ key = "l", mods = "LEADER|CTRL", action = act.ShowDebugOverlay },

		-- paste from the clipboard
		{ key = "Paste", mods = "NONE", action = act.PasteFrom("Clipboard") },
		{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
		-- paste from the primary selection
		{ key = "v", mods = "SUPER", action = act.PasteFrom("PrimarySelection") },
		-- copy to clipboard
		{ key = "Copy", mods = "NONE", action = act.CopyTo("Clipboard") },
		{ key = "c", mods = "SUPER", action = act.CopyTo("ClipboardAndPrimarySelection") },

		{ key = "a", mods = "LEADER|CTRL", action = act({ SendString = "\x01" }) },
		{ key = "-", mods = "LEADER", action = act.SplitPane({ direction = "Down" }) },
		{
			key = "DownArrow",
			mods = "LEADER",
			action = act.SplitPane({ direction = "Down", size = { Percent = 15 }, top_level = false }),
		},
		{
			key = "UpArrow",
			mods = "LEADER",
			action = act.SplitPane({ direction = "Up", size = { Percent = 15 } }),
		},

		{
			key = "\\",
			mods = "LEADER",
			action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },

		{ key = "Enter", mods = "ALT", action = act.ToggleFullScreen },

		{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
		{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },

		{ key = "h", mods = "LEADER", action = act({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "LEADER", action = act({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "LEADER", action = act({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "LEADER", action = act({ ActivatePaneDirection = "Right" }) },

		{ key = "LeftArrow", mods = "ALT|SUPER", action = act({ ActivatePaneDirection = "Left" }) },
		{ key = "RightArrow", mods = "ALT|SUPER", action = act({ ActivatePaneDirection = "Right" }) },
		{ key = "UpArrow", mods = "ALT|SUPER", action = act({ ActivatePaneDirection = "Up" }) },
		{ key = "DownArrow", mods = "ALT|SUPER", action = act({ ActivatePaneDirection = "Down" }) },

		{ key = "h", mods = "SUPER|CTRL", action = act({ AdjustPaneSize = { "Left", 1 } }) },
		{ key = "j", mods = "SUPER|CTRL", action = act({ AdjustPaneSize = { "Down", 1 } }) },
		{ key = "k", mods = "SUPER|CTRL", action = act({ AdjustPaneSize = { "Up", 1 } }) },
		{ key = "l", mods = "SUPER|CTRL", action = act({ AdjustPaneSize = { "Right", 1 } }) },

		{ key = "1", mods = "SUPER", action = act({ ActivateTab = 0 }) },
		{ key = "2", mods = "SUPER", action = act({ ActivateTab = 1 }) },
		{ key = "3", mods = "SUPER", action = act({ ActivateTab = 2 }) },
		{ key = "4", mods = "SUPER", action = act({ ActivateTab = 3 }) },
		{ key = "5", mods = "SUPER", action = act({ ActivateTab = 4 }) },
		{ key = "6", mods = "SUPER", action = act({ ActivateTab = 5 }) },
		{ key = "7", mods = "SUPER", action = act({ ActivateTab = 6 }) },
		{ key = "8", mods = "SUPER", action = act({ ActivateTab = 7 }) },
		{ key = "9", mods = "SUPER", action = act({ ActivateTab = 8 }) },

		{ key = "1", mods = "LEADER", action = act({ ActivateTab = 0 }) },
		{ key = "2", mods = "LEADER", action = act({ ActivateTab = 1 }) },
		{ key = "3", mods = "LEADER", action = act({ ActivateTab = 2 }) },
		{ key = "4", mods = "LEADER", action = act({ ActivateTab = 3 }) },
		{ key = "5", mods = "LEADER", action = act({ ActivateTab = 4 }) },
		{ key = "6", mods = "LEADER", action = act({ ActivateTab = 5 }) },
		{ key = "7", mods = "LEADER", action = act({ ActivateTab = 6 }) },
		{ key = "8", mods = "LEADER", action = act({ ActivateTab = 7 }) },
		{ key = "9", mods = "LEADER", action = act({ ActivateTab = 8 }) },

		{ key = "&", mods = "LEADER|SHIFT", action = act({ CloseCurrentTab = { confirm = false } }) },
		{ key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = false } }) },

		{ key = "f", mods = "SHIFT|ALT", action = "ToggleFullScreen" },
		{ key = "h", mods = "CMD", action = act.HideApplication },
	},
}
