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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-focus = {
      url = "github:nvim-focus/focus.nvim";
      flake = false;
    };

    windline = {
      url = "github:windwp/windline.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, darwin, ... }@inputs:
    let
      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = with inputs; [(
        final: prev:
        let
          inherit (prev.stdenv) system;
        in 
        rec {
          vimPlugins = prev.vimPlugins // {
            windline = prev.vimUtils.buildVimPlugin {
              pname = "windline.nvim";
              src = inputs.windline;
              version = inputs.windline.lastModifiedDate;
            };

            focus = prev.vimUtils.buildVimPlugin {
              pname = "focus.nvim";
              src = inputs.nvim-focus;
              version = inputs.nvim-focus.lastModifiedDate;
            };
          };

        }
        ) ];

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
