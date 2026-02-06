{
  description = "home-manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
      home-manager,
      pkgs,
      ...
    }:
    let
      username = "jacobfoard";
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ pkgs.overlays.default ];
        };

      homeModule = import ./jacobfoard.nix { };

      baseModule =
        { pkgs, ... }:
        {
          home.username = username;
          home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
          nixpkgs.config.allowUnfree = true;
        };

      mkHomeConfiguration =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          modules = [
            baseModule
            homeModule
          ];
        };
    in
    {
      # Single module for nixos/darwin consumers
      homeModules.default = homeModule;

      # Standalone home-manager configurations for each supported system
      # Use: home-manager switch --flake .#jacobfoard-aarch64-darwin
      homeConfigurations =
        builtins.listToAttrs (
          map (system: {
            name = "${username}-${system}";
            value = mkHomeConfiguration system;
          }) supportedSystems
        )
        // {
          # Default alias for convenience (assumes aarch64-darwin for macOS)
          ${username} = mkHomeConfiguration "aarch64-darwin";
        };

      # Quick apply: nix run .#setup
      apps = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
        in
        {
          setup = {
            type = "app";
            program = pkgs.writeShellScript "apply-home" ''
              exec ${
                home-manager.packages.${system}.default
              }/bin/home-manager switch --flake ${self}#${username} "$@"
            '';
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
        in
        {
          default = pkgs.mkShell {
            packages = [ home-manager.packages.${system}.default ];
            shellHook = ''echo "Apply home config: home-manager switch --flake ${self}#${username}-${system}"'';
          };
        }
      );
    };
}
