{
  config,
  pkgs,
  lib,
  currentSystem,
  currentSystemName,
  ...
}:
{
  nix = {
    package = pkgs.nixUnstable;

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
      max-jobs = auto
    '';

    settings = {
      substituters = [
        "https://jacobfoard-dotfiles.cachix.org"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "jacobfoard-dotfiles.cachix.org-1:z/Be4vrLZ+whXwYP+/zwPKSrYo2z84BqMKBuapPjVao="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    cachix
    xclip
    gnome.gnome-tweaks
  ];

  environment.enableAllTerminfo = true;

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  users.mutableUsers = false;

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
