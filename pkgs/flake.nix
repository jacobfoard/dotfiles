{
  description = "Custom packages overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Temporary: staging has Go 1.25.6, unstable is still on 1.25.5
    nixpkgs-staging.url = "github:NixOS/nixpkgs/staging";

    bun2nix.url = "github:nix-community/bun2nix";
    bun2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, nixpkgs-staging, bun2nix }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # Overlay that adds all custom packages
      # Use `final.beads` for gastown dep since beads is added to the overlay
      overlays.default = final: prev: let
        staging = import nixpkgs-staging { inherit (final.stdenv.hostPlatform) system; };
      in {
        argocd-mcp = final.callPackage ./argocd-mcp.nix { };
        av = final.callPackage ./av.nix { };
        # Temporary: use Go 1.25.6 from staging until nixpkgs-unstable catches up
        beads = final.callPackage ./beads.nix {
          buildGoModule = final.buildGoModule.override { go = staging.go_1_25; };
        };
        ccstatusline = final.callPackage ./ccstatusline.nix {
          bun2nix = bun2nix.packages.${final.stdenv.hostPlatform.system}.default;
        };
        # gastown = final.callPackage ./gastown.nix { }; # TODO: gt completion fails in sandbox (bd version timeout)
        kubectl-cnpg = final.callPackage ./kubectl-cnpg.nix { };
      };

      # Export packages for direct access
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          argocd-mcp = pkgs.argocd-mcp;
          av = pkgs.av;
          beads = pkgs.beads;
          ccstatusline = pkgs.ccstatusline;
          # gastown = pkgs.gastown; # TODO: disabled until sandbox build fixed
          kubectl-cnpg = pkgs.kubectl-cnpg;
        }
      );
    };
}