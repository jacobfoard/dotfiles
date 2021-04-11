{ pkgs, lib, ... }:

{
  imports = [
    # Minimal config of Nix related options and shells
    ../../darwin/bootstrap.nix

    ../../modules/darwin/security/pam.nix

    # Other nix-darwin configuration
    ./homebrew.nix
    ./defaults.nix
    # ../../modules/wezterm.nix
  ];

  # Networking
  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    fastlane
    terminal-notifier
    krew
    kubectx
    kubernetes-helm
    kubectl
    kubetail
    tmux
    istioctl
  ];

  # Fonts
  fonts = {
    enableFontDir = true;

    # TODO: Setup operator mono patched font
    fonts = with pkgs; [
      recursive
      (nerdfonts.override { fonts = [ "Hack" "VictorMono" ]; })
    ];
  };


  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
}
