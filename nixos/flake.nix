{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    {
      # NixOS configurations will be defined here
      # Example:
      # nixosConfigurations = {
      #   "server-hostname" = nixpkgs.lib.nixosSystem {
      #     system = "x86_64-linux";
      #     modules = [
      #       ./machines/server-hostname
      #       ./modules/common.nix
      #     ];
      #   };
      # };

      nixosConfigurations = { };
    };
}
