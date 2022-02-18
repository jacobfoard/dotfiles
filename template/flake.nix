{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ ];

        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            bashInteractive
          ];
        };
      });
}
