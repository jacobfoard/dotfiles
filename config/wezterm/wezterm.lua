-- Imports for where we need to reference by name
local wezterm = require("wezterm")
local colors = require("colors")
local keys = require("keys")
local mouse = require("mouse")
-- Importing for side-effects, ie wezterm.on calls
require("status-line")

return {
	color_scheme = colors.color_scheme,
	color_schemes = colors.color_schemes,
	colors = {
		tab_bar = {

			-- The color of the strip that goes along the top of the window
			background = "#0b0022",
		},
	},
	font_size = 15,
	line_height = 1.1,
	-- font = wezterm.font_with_fallback({
	-- {family = "OperatorMonoSSmLig Nerd Font", weight = "Light"},
	-- {family = "Hack Nerd Font"},
	-- "JetBrains Mono",
	-- "Noto Color Emoji",
	-- }),
	-- font = wezterm.font("OperatorMonoSSmLig Nerd Font", {weight = "Light"}),
	font = wezterm.font("Hack Nerd Font Mono"),
	-- font =  wezterm.font("Hack Nerd Font",{weight="Regular", stretch="Normal", italic=false}),
	-- font_locator = "ConfigDirsOnly",
	font_dirs = { "fonts" },
	freetype_load_target = "Light",
	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = keys,

	swallow_mouse_click_on_pane_focus = true,
	tab_bar_at_bottom = true,
	mouse_bindings = mouse,
	ssh_domains = {
		{
			-- This name identifies the domain
			name = "nixos",
			-- The address to connect to
			remote_address = "10.0.0.36",
			-- The username to use on the remote host
			username = "jacobfoard",
		},
	},
}
