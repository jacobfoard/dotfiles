{
  description = "Custom packages overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
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
      overlays.default = final: prev: {
        argocd-mcp = final.callPackage ./argocd-mcp.nix { };
        av = final.callPackage ./av.nix { };
        beads = final.callPackage ./beads.nix { };
        entire-cli = final.callPackage ./entire-cli.nix { };
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
          entire-cli = pkgs.entire-cli;
          # gastown = pkgs.gastown; # TODO: disabled until sandbox build fixed
          kubectl-cnpg = pkgs.kubectl-cnpg;
        }
      );
    };
}