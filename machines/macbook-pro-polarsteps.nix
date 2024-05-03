{ config, pkgs, ... }: {
  # We install Nix using a separate installer so we don't want nix-darwin
  # to manage it for us. This tells nix-darwin to just use whatever is running.
  nix.useDaemon = true;

  # Keep in async with vm-shared.nix. (todo: pull this out into a file)
  nix = {
    # We need to enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
      max-jobs = auto
      bash-prompt-prefix = (nix:$name)\040
      extra-nix-path = nixpkgs=flake:nixpkgs
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

  # zsh is the default shell on Mac and we want to make sure that we're
  # configuring the rc correctly with nix-darwin paths.
  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
    '';
  
  system.keyboard = {
    enableKeyMapping = true;
    nonUS.remapTilde = true;
  };

  environment.shells = with pkgs; [ bashInteractive zsh ];
  environment.systemPackages = with pkgs; [
    cachix
    fastlane
    krew
    kubectx
    kubernetes-helm
    kubectl
    kubetail
  ];
}