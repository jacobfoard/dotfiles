{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mango = {
    #   url = "git+ssh://git@github.com/greenpark/mango.git?ref=main";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-utils.follows = "flake-utils";
    #   };
    # };

    # phoenix = {
    #   url = "git+ssh://git@github.com/greenpark/phoenix.git?ref=main";
    #   # follows = "mango/phoenix";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-utils.follows = "flake-utils";
    #   };
    # };
  };


  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs:
    let
      # pkgs = import nixpkgs {
      #   #   inherit system;
      # };
    in
    {
      defaultTemplate = {
        path = ./template;
        description = "nix flake new -t github:jacobfoard/dotfiles .";
      };


    } // # Join the standard configs with a nix shell for every system
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in

      {
        packages.homeConfigurations."jacobfoard" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./home/home.nix ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cachix
            tree
            statix
            nixpkgs-fmt
          ];
        };
      }
    );
}
