local wezterm = require("wezterm")
local os = require("os")

local dirMap = {
    Left = "h",
    Right = "l",
    Up = "k",
    Down = "j",
}

local function isViProcess(pane) 
    -- get_foreground_process_name On Linux, macOS and Windows, 
    -- the process can be queried to determine this path. Other operating systems 
    -- (notably, FreeBSD and other unix systems) are not currently supported
    return pane:get_foreground_process_name():find('n?vim') ~= nil
    -- return pane:get_title():find("n?vim") ~= nil
end

local function handleNavigation(direction, window, pane)
    if isViProcess(pane) then
        window:perform_action(
            -- This should match the keybinds you set in Neovim.
            wezterm.action.SendKey({ key = dirMap[direction], mods = 'ALT' }),
            pane
        )
    else
        window:perform_action(wezterm.action({ ActivatePaneDirection = direction }), pane)
    end
end

wezterm.on("navigateLeft", function(window, pane)
    handleNavigation("Left", window, pane)
end)
wezterm.on("navigateRight", function(window, pane)
    handleNavigation("Right", window, pane)
end)
wezterm.on("navigateUp", function(window, pane)
    handleNavigation("Up", window, pane)
end)
wezterm.on("navigateDown", function(window, pane)
    handleNavigation("Down", window, pane)
end)

return {
    { key = "MediaNextTrack", action = "ShowTabNavigator" },
    -- tmux things
    { key = "w", mods = "LEADER", action = "ShowTabNavigator" },
    { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
    -- want to replicate new tab in tmux but wezterm defaults to CWD of current pane, so we need to manually set it
    { key = "c", mods = "LEADER", action = wezterm.action.SpawnCommandInNewTab({domain = "DefaultDomain", cwd = "~"}) },
    --
    -- Send comment command
    { key = "/", mods = "SUPER", action = wezterm.action({ SendString = "\x1f\x1f" }) },
    { key = "w", mods = "CMD", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

    {
        key = "LeftArrow",
        mods = "LEADER",
        action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
    },
    {
        key = "RightArrow",
        mods = "LEADER",
        action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
    },
    {
        key = "UpArrow",
        mods = "LEADER",
        action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
    },
    {
        key = "DownArrow",
        mods = "LEADER",
        action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
    },
    { key = "LeftArrow", mods = "CTRL", action = wezterm.action({ EmitEvent = "navigateLeft" }) },
    { key = "RightArrow", mods = "CTRL", action = wezterm.action({ EmitEvent = "navigateRight" }) },
    { key = "UpArrow", mods = "CTRL", action = wezterm.action({ EmitEvent = "navigateUp" }) },
    { key = "DownArrow", mods = "CTRL", action = wezterm.action({ EmitEvent = "navigateDown" }) },
}
