local wezterm = require("wezterm");

return {
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = {Up = {streak = 1, button = "Left"}},
    mods = "NONE",
    action = wezterm.action {CompleteSelection = "ClipboardAndPrimarySelection"},
  },

  -- and make CTRL-Click open hyperlinks
  {event = {Up = {streak = 1, button = "Left"}}, mods = "SUPER", action = "OpenLinkAtMouseCursor"},
}
