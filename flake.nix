{
  description = "Jacob's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    private = {
      url = "git+file:///Users/jacobfoard/code/github.com/jacobfoard/dotfiles-private";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Sub-flakes using nix 2.26 path syntax
    pkgs = {
      url = "path:./pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "path:./darwin";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
      inputs.home-manager.follows = "home-manager";
      inputs.pkgs.follows = "pkgs";
      inputs.home.follows = "home";
      inputs.private.follows = "private";
    };

    home = {
      url = "path:./home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.pkgs.follows = "pkgs";
      inputs.private.follows = "private";
    };

    nixos = {
      url = "path:./nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      pkgs,
      darwin,
      home,
      nixos,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Helper to get pkgs with our overlay applied
      getPkgs =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ pkgs.overlays.default ];
        };
    in
    {
      # Re-export lib from darwin sub-flake
      lib = darwin.lib or { };

      # Re-export the overlay for downstream consumers
      overlays.default = pkgs.overlays.default;

      # Re-export darwinConfigurations from darwin sub-flake
      darwinConfigurations = darwin.darwinConfigurations or { };

      # Re-export nixosConfigurations from nixos sub-flake
      nixosConfigurations = nixos.nixosConfigurations or { };

      # Re-export homeConfigurations from home-manager sub-flake (if standalone)
      homeConfigurations = home.homeConfigurations or { };

      # Re-export home modules for integration with darwin/nixos
      homeModules = home.homeModules or { };

      # Flake template for new projects
      templates.default = {
        path = ./template;
        description = "nix flake new -t github:jacobfoard/dotfiles .";
      };

      # Dev shell with all custom packages for testing
      devShells = forAllSystems (
        system:
        let
          nixpkgsWithOverlay = getPkgs system;
        in
        {
          default = nixpkgsWithOverlay.mkShell {
            packages = with nixpkgsWithOverlay; [
              argocd-mcp
              beads
              # gastown # TODO: disabled until sandbox build fixed
              kubectl-cnpg
              nix-update
            ];
          };
        }
      );
    };
}
