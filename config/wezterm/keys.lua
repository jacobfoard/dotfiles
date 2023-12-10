local wezterm = require("wezterm")
local os = require("os")

local dirMap = {
    Left = "h",
    Right = "l",
    Up = "k",
    Down = "j",
}

local function handleNavigation(direction, window, pane)
    -- local result = os.execute(
    --     "env NVIM_LISTEN_ADDRESS=/tmp/nvim"
    --         .. pane:pane_id()
    --         -- TODO: figure out how to set $PATH in wezterm
    --         .. " /Users/jacobfoard/.nix-profile/bin/wezterm.nvim.navigator "
    --         .. dirMap[direction]
    -- )
    -- -- wezterm.log_info(result)
    -- if result then
    --     -- wezterm.log_info("sending keys to vim")
    --     window:perform_action(wezterm.action({ SendString = "\x17" .. dirMap[direction] }), pane)
    -- else
        -- wezterm.log_info("sending keys to term")
        window:perform_action(wezterm.action({ ActivatePaneDirection = direction }), pane)
    -- end
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
