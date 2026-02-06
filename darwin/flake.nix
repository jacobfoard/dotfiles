{
  description = "nix-darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Local sub-flakes
    home = {
      url = "path:../home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    pkgs = {
      url = "path:../pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      home,
      pkgs,
      ...
    }:
    let
      # Helper to create a darwin system configuration
      mkDarwinSystem =
        {
          system ? "aarch64-darwin",
          hostname,
          username ? "jacobfoard",
          modules ? [ ],
        }:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit username hostname;
          };
          modules = [
            # Apply custom packages overlay
            { nixpkgs.overlays = [ pkgs.overlays.default ]; }

            # Common darwin configuration
            ./modules/common.nix

            # Machine-specific configuration
            ./machines/${hostname}

            # Home-manager integration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = home.homeModules.default;
              home-manager.extraSpecialArgs = { inherit username; };
            }
          ]
          ++ modules;
        };
    in
    {
      darwinConfigurations = {
        # Key must match system hostname; hostname must match machines/ directory
        "Jacobs-MacBook-Pro" = mkDarwinSystem {
          hostname = "macbook-pro-polarsteps";
        };
      };
    };
}
