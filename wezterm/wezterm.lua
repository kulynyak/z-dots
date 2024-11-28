local wezterm = require("wezterm")

-- #region Tab item setup
local process_icons = {
	["bash"] = wezterm.nerdfonts.cod_terminal_bash,
	["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
	["cargo"] = wezterm.nerdfonts.dev_rust,
	["curl"] = wezterm.nerdfonts.mdi_flattr,
	["docker"] = wezterm.nerdfonts.linux_docker,
	["docker-compose"] = wezterm.nerdfonts.linux_docker,
	["gh"] = wezterm.nerdfonts.dev_github_badge,
	["git"] = wezterm.nerdfonts.fa_git,
	["go"] = wezterm.nerdfonts.seti_go2,
	["htop"] = wezterm.nerdfonts.md_align_vertical_top,
	["kubectl"] = wezterm.nerdfonts.linux_docker,
	["kuberlr"] = wezterm.nerdfonts.linux_docker,
	["lazydocker"] = wezterm.nerdfonts.linux_docker,
	["lazygit"] = wezterm.nerdfonts.oct_git_compare,
	["lua"] = wezterm.nerdfonts.seti_lua,
	["make"] = wezterm.nerdfonts.seti_makefile,
	["node"] = wezterm.nerdfonts.mdi_hexagon,
	["ruby"] = wezterm.nerdfonts.cod_ruby,
	["stern"] = wezterm.nerdfonts.linux_docker,
	["sudo"] = wezterm.nerdfonts.fa_hashtag,
	["ssh"] = wezterm.nerdfonts.cod_remote,
	["tmux"] = wezterm.nerdfonts.cod_terminal_tmux,
	["top"] = wezterm.nerdfonts.mdi_chart_donut_variant,
	["watch"] = wezterm.nerdfonts.mdi_clock,
	["vim"] = wezterm.nerdfonts.dev_vim,
	["nvim"] = wezterm.nerdfonts.custom_neovim,
	["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
	["zsh"] = wezterm.nerdfonts.seti_shell,
}

-- Return the Tab's current working directory
local function get_cwd(tab)
	return tab.active_pane.current_working_dir.file_path or ""
end

-- Remove all path components and return only the last value
local function remove_abs_path(path)
	return path:gsub("(.*[/\\])(.*)", "%2")
end

-- Return the pretty path of the tab's current working directory
local function get_display_cwd(tab)
	local current_dir = get_cwd(tab)
	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))
	return current_dir == HOME_DIR and "~/" or remove_abs_path(current_dir)
end

-- Return the concise name or icon of the running process for display
local function get_process(tab)
	if not tab.active_pane or tab.active_pane.foreground_process_name == "" then
		return "[?]"
	end

	local process_name = remove_abs_path(tab.active_pane.foreground_process_name)
	if process_name:find("kubectl") then
		process_name = "kubectl"
	end

	return process_icons[process_name] or string.format("[%s]", process_name)
end

-- Pretty format the tab title
local function format_title(tab)
	local cwd = get_display_cwd(tab)
	local process = get_process(tab)

	local active_title = tab.active_pane.title
	if active_title:find("- NVIM") then
		active_title = active_title:gsub("^([^ ]+) .*", "%1")
	end

	local description = (not active_title or active_title == cwd) and "~" or active_title
	local index = tab.tab_index + 1
	return string.format(" %d %s %s %s ", index, process, cwd, description)
end

-- Determine if a tab has unseen output since last visited
local function has_unseen_output(tab)
	if not tab.is_active then
		for _, pane in ipairs(tab.panes) do
			if pane.has_unseen_output then
				return true
			end
		end
	end
	return false
end

-- Returns manually set title (from `tab:set_title()` or `wezterm cli set-tab-title`) or creates a new one
local function get_tab_title(tab)
	local title = tab.tab_title
	if title and #title > 0 then
		return title
	end
	return format_title(tab)
end

-- Convert arbitrary strings to a unique hex color value
-- Based on: https://stackoverflow.com/a/3426956/3219667
local function string_to_color(str)
	-- Convert the string to a unique integer
	local hash = 0
	for i = 1, #str do
		hash = string.byte(str, i) + ((hash << 5) - hash)
	end

	-- Convert the integer to a unique color
	local c = string.format("%06X", hash & 0xFF0000)
	return "#" .. (string.rep("0", 6 - #c) .. c):upper()
end

local function select_contrasting_fg_color(hex_color)
	-- Note: this could use `return color:complement_ryb()` instead if you prefer or other builtins!

	local color = wezterm.color.parse(hex_color)
	---@diagnostic disable-next-line: unused-local
	local lightness, _a, _b, _alpha = color:laba()
	if lightness > 55 then
		return "#000000" -- Black has higher contrast with colors perceived to be "bright"
	end
	return "#FFFFFF" -- White has higher contrast
end

-- On format tab title events, override the default handling to return a custom title
-- Docs: https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html
---@diagnostic disable-next-line: unused-local
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = get_tab_title(tab)
	local color = string_to_color(get_cwd(tab))
	if tab.is_active then
		return {
			{
				Attribute = {
					Intensity = "Bold",
				},
			},
			{
				Background = {
					Color = color,
				},
			},
			{
				Foreground = {
					Color = select_contrasting_fg_color(color),
				},
			},
			{
				Text = title,
			},
		}
	end
	if has_unseen_output(tab) then
		return {
			{
				Foreground = {
					Color = "lightgray",
				},
			},
			{
				Text = title,
			},
		}
	end
	return title
end)
-- #endregion Tab item setup

-- #region Dynamic Setup
-- Define your light and dark color schemes
local light_schemes = {
	"Catppuccin Latte",
}
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
local dark_scheme = "duckbones"
-- local default_scheme = "Pencil Dark (Gogh)"
local default_scheme = "Catppuccin Mocha"
-- local default_scheme = "MaterialDarker"
-- local default_scheme = "Bleh-1 (terminal.sexy)"
-- local default_scheme = "Blue Matrix"
-- local default_scheme = "Brogrammer (Gogh)"
-- local default_scheme = "iTerm2 Dark Background"
-- local default_scheme = "Monokai Remastered"
-- local default_scheme = "Nocturnal Winter"
-- local default_scheme = "duckbones" -- good

-- Helper function to check if a table contains a value
local function table_contains(tbl, element)
	for _, value in pairs(tbl) do
		if value == element then
			return true
		end
	end
	return false
end

-- Function to set color scheme
local function set_color_scheme(window, scheme_name)
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

-- Function to toggle the light color scheme
local function toggle_light_scheme(window)
	set_color_scheme(window, light_scheme)
end

-- Function to toggle the dark color scheme
local function toggle_dark_scheme(window)
	set_color_scheme(window, dark_scheme)
end

-- Default configuration
wezterm.on("update-right-status", function(_, _) end)

wezterm.on("window-config-reloaded", function(window, _)
	window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

local window_padding = 5
local act = wezterm.action

-- #endregion Dynamic Setup

return {
	-- #region Window settings
	-- Exit confirmation
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",

	window_background_opacity = 0.90,
	text_background_opacity = 0.9,
	macos_window_background_blur = 10,

	window_frame = {
		border_left_width = "1.0px",
		border_right_width = "1.0px",
		border_bottom_height = "1.0px",
		border_top_height = "1.0px",
		border_left_color = "#444",
		border_right_color = "#444",
		border_bottom_color = "#444",
		border_top_color = "#444",
	},

	initial_cols = 196,
	initial_rows = 85,

	adjust_window_size_when_changing_font_size = true,

	window_padding = {
		left = window_padding,
		right = window_padding,
		top = window_padding,
		bottom = window_padding,
	},
	-- #endregion Window settings

	-- #region Pane settings
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.8,
	},
	-- #endregion Pane settings

	-- #region Scroll settings
	enable_scroll_bar = false,
	scrollback_lines = 10000,
	-- #endregion Scroll settings

	front_end = "OpenGL",

	-- #region Colorscheme
	color_scheme = default_scheme,
	-- #endregion Colorscheme

	-- #region Colors
	colors = {
		-- color of the split lines between panes
		split = "#AABBAA",
	},
	-- #endregion Colors

	-- #region Cursor settings
	-- default_cursor_style = "SteadyBar",
	cursor_blink_rate = 500, -- Adjust this for the blinking rate (in milliseconds)
	cursor_blink_ease_in = "Linear",
	cursor_blink_ease_out = "Linear",
	cursor_thickness = "2px",
	-- #endregion Cursor settings

	-- #region Font settings
	font_size = 13.0,
	line_height = 0.97,
	freetype_load_target = "Light",
	font = wezterm.font_with_fallback({
		"FiraCode Nerd Font Mono",
		"JetBrainsMono Nerd Font Mono",
		"Hack Nerd Font Mono",
		"Fira Code",
		"FiraMono Nerd Font Mono",
	}),
	-- #endregion Font settings

	-- #region Tab bar settings
	use_fancy_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	-- #endregion Tab bar settings

	-- #region Uncategirized settings
	check_for_updates = true,
	automatically_reload_config = true,
	-- native_macos_fullscreen_mode = true,
	native_macos_fullscreen_mode = false,
	-- #endregion Uncategirized settings

	-- #region Key bindings
	disable_default_key_bindings = true,
	leader = {
		key = "a",
		mods = "SUPER",
	},
	keys = { -- switch to dark theme
		{
			key = "1",
			mods = "CTRL|ALT",
			action = wezterm.action_callback(toggle_dark_scheme),
		}, -- switch to light theme
		{
			key = "2",
			mods = "CTRL|ALT",
			action = wezterm.action_callback(toggle_light_scheme),
		}, -- spawn a new window
		{
			key = "n",
			mods = "SUPER",
			action = act.SpawnWindow,
		}, -- open wezterm config
		{
			key = ",",
			mods = "SUPER",
			action = act.SpawnCommandInNewTab({
				cwd = os.getenv("WEZTERM_CONFIG_DIR"),
				set_environment_variables = {
					TERM = "screen-256color",
					NVIM_APPNAME = "LazyVim", -- Set this directly in the wezterm config
				},
				args = {
					"/opt/homebrew/bin/nvim", -- You can keep the direct path to nvim
					os.getenv("WEZTERM_CONFIG_FILE"),
				},
			}),
		}, -- reset font size
		{
			key = "0",
			mods = "CTRL|SUPER",
			action = act.ResetFontSize,
		}, -- increase font size
		{
			key = "=",
			mods = "CTRL|SUPER",
			action = act.IncreaseFontSize,
		}, -- decrease font size
		{
			key = "-",
			mods = "CTRL|SUPER",
			action = act.DecreaseFontSize,
		}, -- show tab bar navigator
		{
			key = "t",
			mods = "SUPER|SHIFT",
			action = act.ShowTabNavigator,
		}, -- enter debug console
		{
			key = "l",
			mods = "LEADER|CTRL",
			action = act.ShowDebugOverlay,
		}, -- paste from the clipboard
		{
			key = "Paste",
			mods = "NONE",
			action = act.PasteFrom("Clipboard"),
		},
		{
			key = "v",
			mods = "SUPER",
			action = act.PasteFrom("Clipboard"),
		}, -- paste from the primary selection
		{
			key = "v",
			mods = "SUPER",
			action = act.PasteFrom("PrimarySelection"),
		}, -- copy to clipboard
		{
			key = "Copy",
			mods = "NONE",
			action = act.CopyTo("Clipboard"),
		},
		{
			key = "c",
			mods = "SUPER",
			action = act.CopyTo("ClipboardAndPrimarySelection"),
		}, -- tmux prefix (alt+a)
		{
			key = "a",
			mods = "LEADER|CTRL",
			action = act({
				SendString = "\x01",
			}),
		}, -- split pane down
		{
			key = "-",
			mods = "LEADER",
			action = act.SplitPane({
				direction = "Down",
			}),
		},
		{
			key = "DownArrow",
			mods = "LEADER",
			action = act.SplitPane({
				direction = "Down",
				size = {
					Percent = 15,
				},
				top_level = false,
			}),
		}, -- split pane up
		{
			key = "UpArrow",
			mods = "LEADER",
			action = act.SplitPane({
				direction = "Up",
				size = {
					Percent = 15,
				},
			}),
		}, -- split horizontal
		{
			key = "\\",
			mods = "LEADER",
			action = act({
				SplitHorizontal = {
					domain = "CurrentPaneDomain",
				},
			}),
		}, -- activate tab right
		{
			key = "Tab",
			mods = "CTRL",
			action = act.ActivateTabRelative(1),
		}, -- activate tab left
		{
			key = "Tab",
			mods = "SHIFT|CTRL",
			action = act.ActivateTabRelative(-1),
		}, -- toggle full screen
		{
			key = "Enter",
			mods = "ALT",
			action = act.ToggleFullScreen,
		},
		{
			key = "f",
			mods = "SHIFT|ALT",
			action = "ToggleFullScreen",
		}, -- toggle pane zoom state
		{
			key = "z",
			mods = "LEADER",
			action = "TogglePaneZoomState",
		}, -- create new tab
		{
			key = "c",
			mods = "LEADER",
			action = act({
				SpawnTab = "CurrentPaneDomain",
			}),
		}, -- go to left pane
		{
			key = "LeftArrow",
			mods = "ALT|SUPER",
			action = act({
				ActivatePaneDirection = "Left",
			}),
		},
		{
			key = "h",
			mods = "LEADER",
			action = act({
				ActivatePaneDirection = "Left",
			}),
		}, -- go to right pane
		{
			key = "RightArrow",
			mods = "ALT|SUPER",
			action = act({
				ActivatePaneDirection = "Right",
			}),
		},
		{
			key = "l",
			mods = "LEADER",
			action = act({
				ActivatePaneDirection = "Right",
			}),
		}, -- go to down pane
		{
			key = "j",
			mods = "LEADER",
			action = act({
				ActivatePaneDirection = "Down",
			}),
		},
		{
			key = "DownArrow",
			mods = "ALT|SUPER",
			action = act({
				ActivatePaneDirection = "Down",
			}),
		}, -- go to up pane
		{
			key = "UpArrow",
			mods = "ALT|SUPER",
			action = act({
				ActivatePaneDirection = "Up",
			}),
		},
		{
			key = "k",
			mods = "LEADER",
			action = act({
				ActivatePaneDirection = "Up",
			}),
		}, -- resize pane left
		{
			key = "h",
			mods = "SUPER|CTRL",
			action = act({
				AdjustPaneSize = {
					"Left",
					1,
				},
			}),
		}, -- resize pane down
		{
			key = "j",
			mods = "SUPER|CTRL",
			action = act({
				AdjustPaneSize = {
					"Down",
					1,
				},
			}),
		}, -- resize pane up
		{
			key = "k",
			mods = "SUPER|CTRL",
			action = act({
				AdjustPaneSize = {
					"Up",
					1,
				},
			}),
		}, -- resize pane right
		{
			key = "l",
			mods = "SUPER|CTRL",
			action = act({
				AdjustPaneSize = {
					"Right",
					1,
				},
			}),
		}, -- select tab 1-9 super
		{
			key = "1",
			mods = "SUPER",
			action = act({
				ActivateTab = 0,
			}),
		},
		{
			key = "2",
			mods = "SUPER",
			action = act({
				ActivateTab = 1,
			}),
		},
		{
			key = "3",
			mods = "SUPER",
			action = act({
				ActivateTab = 2,
			}),
		},
		{
			key = "4",
			mods = "SUPER",
			action = act({
				ActivateTab = 3,
			}),
		},
		{
			key = "5",
			mods = "SUPER",
			action = act({
				ActivateTab = 4,
			}),
		},
		{
			key = "6",
			mods = "SUPER",
			action = act({
				ActivateTab = 5,
			}),
		},
		{
			key = "7",
			mods = "SUPER",
			action = act({
				ActivateTab = 6,
			}),
		},
		{
			key = "8",
			mods = "SUPER",
			action = act({
				ActivateTab = 7,
			}),
		},
		{
			key = "9",
			mods = "SUPER",
			action = act({
				ActivateTab = 8,
			}),
		}, -- select tab 1-9 leader
		{
			key = "1",
			mods = "LEADER",
			action = act({
				ActivateTab = 0,
			}),
		},
		{
			key = "2",
			mods = "LEADER",
			action = act({
				ActivateTab = 1,
			}),
		},
		{
			key = "3",
			mods = "LEADER",
			action = act({
				ActivateTab = 2,
			}),
		},
		{
			key = "4",
			mods = "LEADER",
			action = act({
				ActivateTab = 3,
			}),
		},
		{
			key = "5",
			mods = "LEADER",
			action = act({
				ActivateTab = 4,
			}),
		},
		{
			key = "6",
			mods = "LEADER",
			action = act({
				ActivateTab = 5,
			}),
		},
		{
			key = "7",
			mods = "LEADER",
			action = act({
				ActivateTab = 6,
			}),
		},
		{
			key = "8",
			mods = "LEADER",
			action = act({
				ActivateTab = 7,
			}),
		},
		{
			key = "9",
			mods = "LEADER",
			action = act({
				ActivateTab = 8,
			}),
		}, -- close tab
		{
			key = "&",
			mods = "LEADER|SHIFT",
			action = act({
				CloseCurrentTab = {
					confirm = false,
				},
			}),
		},
		{
			key = "x",
			mods = "LEADER",
			action = act({
				CloseCurrentPane = {
					confirm = false,
				},
			}),
		}, -- hide application
		{
			key = "h",
			mods = "CMD",
			action = act.HideApplication,
		}, -- exit wezterm
		{
			key = "q",
			mods = "CMD",
			action = wezterm.action.QuitApplication,
		},
	},
	-- #endregion Key bindings
}
