local wezterm = require("wezterm");

local function handleNavigation(direction, window, pane)
  local isVim = string.gsub(pane:get_title(), ".*vim", "")
  if isVim == "" then
    local vimMap = {Left = "\x08", Right = "\x0c", Up = "\x0b", Down = "\x0a"}

    window:perform_action(wezterm.action {SendString = "\x17" .. vimMap[direction]}, pane)
  else
    window:perform_action(wezterm.action {ActivatePaneDirection = direction}, pane)
  end
end

wezterm.on("navigateLeft", function(window, pane) handleNavigation("Left", window, pane) end)
wezterm.on("navigateRight", function(window, pane) handleNavigation("Right", window, pane) end)
wezterm.on("navigateUp", function(window, pane) handleNavigation("Up", window, pane) end)
wezterm.on("navigateDown", function(window, pane) handleNavigation("Down", window, pane) end)

return {
  {key = "MediaNextTrack", action = "ShowTabNavigator"},
  -- tmux things
  {key = "w", mods = "LEADER", action = "ShowTabNavigator"},
  {key = "z", mods = "LEADER", action = "TogglePaneZoomState"},
  {key = "c", mods = "LEADER", action = wezterm.action {SpawnTab = "CurrentPaneDomain"}},
  --
  -- Send comment command
  {key = "/", mods = "SUPER", action = wezterm.action {SendString = "\x1f\x1f"}},
  {key = "w", mods = "CMD", action = wezterm.action {CloseCurrentPane = {confirm = true}}},

  {
    key = "LeftArrow",
    mods = "LEADER",
    action = wezterm.action {SplitHorizontal = {domain = "CurrentPaneDomain"}},
  },
  {
    key = "RightArrow",
    mods = "LEADER",
    action = wezterm.action {SplitHorizontal = {domain = "CurrentPaneDomain"}},
  },
  {
    key = "UpArrow",
    mods = "LEADER",
    action = wezterm.action {SplitVertical = {domain = "CurrentPaneDomain"}},
  },
  {
    key = "DownArrow",
    mods = "LEADER",
    action = wezterm.action {SplitVertical = {domain = "CurrentPaneDomain"}},
  },
  {key = "LeftArrow", mods = "CTRL", action = wezterm.action {EmitEvent = "navigateLeft"}},
  {key = "RightArrow", mods = "CTRL", action = wezterm.action {EmitEvent = "navigateRight"}},
  {key = "UpArrow", mods = "CTRL", action = wezterm.action {EmitEvent = "navigateUp"}},
  {key = "DownArrow", mods = "CTRL", action = wezterm.action {EmitEvent = "navigateDown"}},
}
