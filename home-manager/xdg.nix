{ ... }:

{
  config = {
    xdg.enable = true;

    xdg.configFile."wezterm/colors.lua".source = ./wezterm/colors.lua;
    xdg.configFile."wezterm/init.lua".source = ./wezterm/init.lua;
    xdg.configFile."wezterm/keys.lua".source = ./wezterm/keys.lua;
    xdg.configFile."wezterm/mouse.lua".source = ./wezterm/mouse.lua;
    xdg.configFile."wezterm/status-line.lua".source = ./wezterm/status-line.lua;

    xdg.configFile."ghostty/config".source = ./ghostty;
  };
}
