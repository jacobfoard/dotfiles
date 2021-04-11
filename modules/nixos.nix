{ config, pkgs, ... }:
{
  imports = [
    ./nix.nix
  ];

  nix = {
    autoOptimiseStore = true;
    optimise.automatic = true;
  };
}
