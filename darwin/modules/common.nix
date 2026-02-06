{
  config,
  pkgs,
  username,
  ...
}:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Required for Determinate Nix builds
  ids.gids.nixbld = 30000;

  # Nix configuration (Determinate Nix manages the daemon, so nix.enable = false)
  nix = {
    enable = false;
    package = pkgs.nix;

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
      max-jobs = auto
      bash-prompt-prefix = (nix:$name)\040
      extra-nix-path = nixpkgs=flake:nixpkgs
      extra-experimental-features = external-builders
      external-builders = [{"systems":["aarch64-linux","x86_64-linux"],"program":"/usr/local/bin/determinate-nixd","args":["builder"]}]
    '';

    settings = {
      trusted-users = [
        "root"
        username
      ];
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

  # # Determinate Nix custom settings
  # determinate-nix.customSettings = {
  #   trusted-users = [
  #     "root"
  #     username
  #   ];
  # };

  # Set the primary user for system configuration
  system.primaryUser = username;

  # System state version
  system.stateVersion = 5;

  # zsh is the default shell on Mac
  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
  '';

  # Keyboard configuration
  system.keyboard = {
    enableKeyMapping = true;
    nonUS.remapTilde = true;
  };

  # Global system defaults
  system.defaults.NSGlobalDomain.AppleICUForce24HourTime = true;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  # Available shells
  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];

  # Add ability to use TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;
}
