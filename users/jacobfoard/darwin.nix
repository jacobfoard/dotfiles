{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = import ../../lib/overlays.nix;
  nixpkgs.config.allowUnfree = true;


  homebrew = {
    enable = false;
    casks  = [
      "1password"
      "1password-cli"
      "dbeaver-community"
      "firefox"
      "itsycal"
      "orbstack"
      "raycast"
      "rectangle"
      "slack"
      "spotify"
    ];

    masApps = {
      Amphetamine = 937984704;
      Clocker = 1056643111;
      Tailscale = 1475387142;
      Xcode = 497799835;
    };


    brews = [ ];
  };

  fonts = {
    fontDir.enable = true;

    # TODO: Setup operator mono patched font
    fonts = with pkgs; [
      recursive
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  networking = {
    knownNetworkServices = [
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };


  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.jacobfoard = {
    home = "/Users/jacobfoard";
    shell = pkgs.zsh;
  };
}