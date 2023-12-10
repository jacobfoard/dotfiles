{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-23.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, flake-utils, home-manager, darwin, ... }@inputs:
    let
      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = [ ];

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


    } // # Join the standard configs with a nix shell for every system
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # inherit overlays;
        };
        # stable-pkgs = if system == "x86_64-darwin" then inputs.nixpkgs-stable-darwin else inputs.nixos-stable;
        # stable = stable-pkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cachix
          ];
        };
      }
    );
}
