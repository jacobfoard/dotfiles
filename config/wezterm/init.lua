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
    bold_brightens_ansi_colors = false,
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,

    font_size = 16,
    -- JetBrainsMono for most things, but some weird things like ⋅ need Hack as the fallback
    font = wezterm.font_with_fallback({
        { family = "JetBrainsMono Nerd Font" },
        { family = "Hack Nerd Font" },
    }),

    leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
    keys = keys,
    mouse_bindings = mouse,
    swallow_mouse_click_on_pane_focus = true,
    set_environment_variables = {
        TERMINFO_DIRS = '/Users/jacobfoard/.nix-profile/share/terminfo',
        WSLENV = 'TERMINFO_DIRS',
      },
    term = "wezterm",
    unzoom_on_switch_pane = false,
    window_decorations = "RESIZE",

    unix_domains = {
        {
            name = "unix",
        },
    },

    default_gui_startup_args = { "connect", "unix" },

    window_padding = {
        left = 10,
        right = 10,
        top = 3,
        bottom = 0,
    },
}
