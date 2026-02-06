local wezterm = require("wezterm")

local function u(code)
    return utf8.char("0x" .. code)
end

-- Todo figure out why this errors
wezterm.on("update-weather", function(min)
    -- if min == "31" then
    local success, stdout, stderr = wezterm.run_child_process({
        "curl",
        "wttr.in/Redwood City?format=3",
    })
    -- local success, stdout, stderr = wezterm.run_child_process({"ls"})
    -- wezterm.log_info(success)
    wezterm.log_info(stdout)
    -- wezterm.log_info(stderr)
    -- end
    return true
end)

wezterm.on("update-right-status", function(window, pane)
    -- local overrides = window:get_config_overrides() or {}
    -- overrides.color_scheme = ""
    -- window:set_config_overrides(overrides)
    local user, _ = string.gsub(wezterm.home_dir, "/.*/", "")
    --  https://docs.rs/chrono/0.4.19/chrono/format/strftime/index.html
    local date = wezterm.strftime("%H:%M:%S " .. u("E0B3") .. " %A %b %-d ")

    -- local co =  coroutine.create(function (t)
    --     wezterm.emit("update-weather",t)
    --     coroutine.yield()
    --   end)
    --
    -- coroutine.resume(co, wezterm.strftime("%M"))

    -- TODO: Setup like tmux, dynamic color bar, charging status, etc
    local bat = ""
    for _, b in ipairs(wezterm.battery_info()) do
        bat = "🔋" .. string.format("%.0f%%", b.state_of_charge * 100)
    end

    window:set_right_status(wezterm.format({
        {
            Text = bat
                .. " "
                .. u("E0B3")
                .. date
                .. u("E0B2")
                .. " "
                .. user
                .. " "
                .. u("E0B2")
                .. " "
                .. wezterm.hostname(),
        },
    }))
end)
--
-- wezterm.on("update-right-status", function(window, pane)
--   -- demonstrates shelling out to get some external status.
--   -- wezterm will parse escape sequences output by the
--   -- child process and include them in the status area, too.
--   local success, date, stderr = wezterm.run_child_process({"date"})
--   -- wezterm.log_info(success)
--   wezterm.log_info(date)
--   -- wezterm.log_info(stderr)
--
--   -- Make it italic and underlined
--   window:set_right_status(wezterm.format({
--     {Attribute={Underline="Single"}},
--     {Attribute={Italic=true}},
--     {Text="Hello "..date},
--   }));
-- end)
