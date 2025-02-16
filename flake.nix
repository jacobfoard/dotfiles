{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      home-manager,
      darwin,
      ...
    }@inputs:
    let
      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = with inputs; [
        (
          final: prev:
          let
            inherit (prev.stdenv) system;
          in
          rec {

          }
        )
      ];

      mkSystem = import ./lib/mksystem.nix {
        inherit overlays nixpkgs inputs;
      };
    in
    {
      defaultTemplate = {
        path = ./template;
        description = "nix flake new -t github:jacobfoard/dotfiles .";
      };

      nixosConfigurations.desktop = mkSystem "desktop" rec {
        system = "x86_64-linux";
        user = "jacobfoard";
      };

      darwinConfigurations.Jacobs-MacBook-Pro = mkSystem "macbook-pro-polarsteps" {
        system = "aarch64-darwin";
        user = "jacobfoard";
        darwin = true;
      };

    }
    # Join the standard configs with a nix shell for every system
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # inherit overlays;
        };
      in
      # stable-pkgs = if system == "x86_64-darwin" then inputs.nixpkgs-stable-darwin else inputs.nixos-stable;
      # stable = stable-pkgs.legacyPackages.${system};
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cachix
            nixfmt-rfc-style
          ];
        };
      }
    );
}
