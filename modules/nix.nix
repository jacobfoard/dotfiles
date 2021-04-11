{ config, pkgs, lib, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    trustedUsers = [
      "@admin"
      "jacobfoard"
    ];

    nixPath = [
      "nixpkgs=${pkgs.path}"
    ];

    # gc.automatic = true;

    extraOptions = ''
      builders-use-substitutes = true
      max-jobs = auto
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
  };
}
