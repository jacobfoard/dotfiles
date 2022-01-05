{ config, pkgs, lib, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    binaryCaches = [
      "https://jacobfoard-dotfiles.cachix.org"
      "https://greenpark.cachix.org"
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];

    binaryCachePublicKeys = [
      "jacobfoard-dotfiles.cachix.org-1:z/Be4vrLZ+whXwYP+/zwPKSrYo2z84BqMKBuapPjVao="
      "greenpark.cachix.org-1:X87ybPzzU4T5kEj5V3y07KHMDZQOojOgnFIWilRFkd8="
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
