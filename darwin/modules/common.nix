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

  # Determinate Nix manages the daemon and /etc/nix/nix.conf.
  # determinateNix.enable = true sets nix.enable = false automatically.
  determinateNix.customSettings = {
    keep-outputs = true;
    keep-derivations = true;
    builders-use-substitutes = true;
    trusted-users = [
      "root"
      username
    ];
    extra-substituters = [
      "https://jacobfoard-dotfiles.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "jacobfoard-dotfiles.cachix.org-1:z/Be4vrLZ+whXwYP+/zwPKSrYo2z84BqMKBuapPjVao="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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
