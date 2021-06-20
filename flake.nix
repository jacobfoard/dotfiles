{
  description = "Jacob's dotfiles";
  inputs = {
    # Generally living on the edge
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    # Stable for when shit is broken
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-21.05";

    flake-utils.url = "github:numtide/flake-utils";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = github:Mic92/sops-nix;

    codedark = {
      url = "github:jacobfoard/vim-code-dark/personal-changes";
      flake = false;
    };

    ts-server = {
      url = "github:theia-ide/typescript-language-server";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixos, darwin, home-manager, flake-utils, sops-nix, ... }@inputs:
    let
      overlays = with inputs; [
        neovim-nightly-overlay.overlay
        (
          final: prev:
            let
              system = prev.stdenv.system;
              nixpkgs-stable = if system == "x86_64-darwin" then nixpkgs-stable-darwin else nixos-stable;
            in
            {
              master = nixpkgs-master.legacyPackages.${system};
              stable = nixpkgs-stable.legacyPackages.${system};

              # Temporaray overides for packages we use that are currently broken on `unstable`
              thefuck = prev.thefuck.overrideAttrs (old: { doInstallCheck = false; });

              # Install colorscheme via input so it just works
              vimPlugins = prev.vimPlugins // {
                codedark = prev.vimUtils.buildVimPluginFrom2Nix {
                  pname = "vim-code-dark";
                  version = inputs.codedark.lastModifiedDate;
                  src = inputs.codedark;
                };
              };

              nodePackages = prev.nodePackages // {
                typescript-server = prev.nodePackages.typescript-language-server.overrideAttrs (old: {
                  name = "typescript-server";
                  packageName = "typescript-server";
                  src = inputs.ts-server;
                  version = "0.5.2";
                });
              };
            }
        )
      ];

      nixpkgsConfig = with inputs; {
        config = { allowUnfree = true; };
        overlays = overlays;
      };

      homeManagerCommonConfig = with self; {
        imports = [
          ./home/home.nix
        ];
      };

      # Modules shared by most `nix-darwin` personal configurations.
      nixDarwinCommonModules = { user }: [
        # Include extra `nix-darwin`
        # self.darwinModules.programs.nix-index
        # self.darwinModules.security.pam
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          users.users.${user}.home = "/Users/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = homeManagerCommonConfig;
        }
        sops-nix.nixosModules.sops
      ];
    in
    {
      defaultIso = self.nixosConfigurations.defaultIso.config.system.build.isoImage;
      linodeIso = self.nixosConfigurations.linodeIso.config.system.build.isoImage;


      darwinConfigurations = {
        # darwin requires an inital bootstrapping
        bootstrap = darwin.lib.darwinSystem {
          modules = [
            ./darwin/bootstrap.nix
            {
              nixpkgs = nixpkgsConfig;
            }
          ];
        };

        Wozniak = darwin.lib.darwinSystem {
          modules = nixDarwinCommonModules { user = "jacobfoard"; } ++ [
            ./machines/wozniak/configuration.nix
            {
              networking.computerName = "Jacob’s 💻";
              networking.hostName = "Wozniak";
              networking.knownNetworkServices = [
                "Ethernet"
                "Wi-Fi"
                "USB3.0 5K Graphic Docking"
                "Tailscale Tunnel"
              ];
            }
          ];
        };
      };

      nixosConfigurations = {
        linode = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/linode/configuration.nix
            {
              nixpkgs = nixpkgsConfig;
            }
          ];
        };

        # General Server for experimentation
        cerf = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/cerf/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jacobfoard = import ./home/home.nix;
            }
          ];
        };

        # Media Server
        cohen = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/cohen/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jacobfoard = import ./home/home.nix;
            }
          ];
        };

        defaultIso = nixos.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
            ./isos/general
            home-manager.nixosModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nixos = import ./home/home.nix;
            }
          ];
        };

        linodeIso = nixos.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
            ./isos/linode
            home-manager.nixosModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nixos = import ./home/home.nix;
            }
          ];
        };
      };
    } // # Join the standard configs with a nix shell for every system
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            tree
            nodejs
            ncurses
            sops
            fontconfig
            luaformatter
          ];
        };
      });
}
