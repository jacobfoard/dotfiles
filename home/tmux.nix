{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    # standard tmux with a wrapper to ensure login profile is ran correctly 
    tmux-darwin
  ];

  # Use upstream tmux conf for std
  home.file.".tmux.conf".source = "${pkgs.tmux-base}/.tmux.conf";

  # Local overrides
  home.file.".tmux.conf.local".source = ../config/tmux/tmux.conf.local;
}
