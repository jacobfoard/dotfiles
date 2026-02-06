local wezterm = require("wezterm")

-- smart-splits.nvim sets IS_NVIM user var when loaded
local function is_vim(pane)
  return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
  LeftArrow = "Left",
  DownArrow = "Down",
  UpArrow = "Up",
  RightArrow = "Right",
}

local function split_nav(key)
  return {
    key = key,
    mods = "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- Pass through to nvim (smart-splits handles the rest)
        win:perform_action({ SendKey = { key = key, mods = "CTRL" } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
      end
    end),
  }
end

return {
  { key = "MediaNextTrack", action = "ShowTabNavigator" },
  -- tmux-like bindings
  { key = "w", mods = "LEADER", action = "ShowTabNavigator" },
  { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
  { key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
  -- want to replicate new tab in tmux but wezterm defaults to CWD of current pane, so we need to manually set it
  { key = "c", mods = "LEADER", action = wezterm.action.SpawnCommandInNewTab({ domain = "DefaultDomain", cwd = "~" }) },

  -- Send comment command
  { key = "/", mods = "SUPER", action = wezterm.action({ SendString = "\x1f\x1f" }) },
  { key = "w", mods = "CMD", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

  -- Create splits with LEADER+Arrow
  { key = "LeftArrow", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
  { key = "RightArrow", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
  { key = "UpArrow", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
  { key = "DownArrow", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },

  -- Navigate with Ctrl+Arrow (smart-splits integration)
  split_nav("LeftArrow"),
  split_nav("RightArrow"),
  split_nav("UpArrow"),
  split_nav("DownArrow"),
}
