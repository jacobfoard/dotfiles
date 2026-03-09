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
      overlays.default = final: prev: {
        # argocd-mcp = final.callPackage ./argocd-mcp.nix { };
        av = final.callPackage ./av.nix { };
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
          # argocd-mcp = pkgs.argocd-mcp;
          av = pkgs.av;
          kubectl-cnpg = pkgs.kubectl-cnpg;
        }
      );
    };
}
