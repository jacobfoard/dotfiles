{
  description = "Jacob's dotfiles";
  inputs = {
    # Generally living on the edge
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    # Stable for when shit is broken
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-21.11";

    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      # url = "github:LnL7/nix-darwin";
      url = "github:jacobfoard/nix-darwin/waiting-on-upstream";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-src = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codedark = {
      url = "github:jacobfoard/vim-code-dark/personal-changes";
      flake = false;
    };

    oh-my-tmux = {
      url = "github:gpakosz/.tmux";
      flake = false;
    };

    spicetify = {
      # TODO: Add in job to update tag https://github.com/khanhas/spicetify-cli/releases
      url = "github:khanhas/spicetify-cli?ref=v2.9.0";
      flake = false;
    };

    # wezterm-nvim = {
    #   url = "github:aca/wezterm.nvim";
    #   flake = false;
    # };

    # nvim-tree-sitter = {
    #   url = "github:nvim-treesitter/nvim-treesitter?ref=b05803402965395cfab2c3e9c0258f494dac377d";
    #   flake = false;
    # };

    mango = {
      url = "git+ssh://git@github.com/greenpark/mango.git?ref=main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    phoenix = {
      url = "git+ssh://git@github.com/greenpark/phoenix.git?ref=main";
      follows = "mango/phoenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };


  outputs = { self, nixpkgs, nixos, darwin, home-manager, flake-utils, mango, phoenix, ... }@inputs:
    let
      overlays = with inputs; [
        # neovim-nightly-overlay.overlay
        (
          final: prev:
            let
              inherit (prev.stdenv) system;
              nixpkgs-stable = if prev.stdenv.isDarwin then nixpkgs-stable-darwin else nixos-stable;
            in
            rec {
              mango_gpsd = mango.defaultPackage.${system};
              inherit (phoenix.packages.${system}) golines;
              graphite = phoenix.packages.${system}.graphite-cli;
              bazel_4 = phoenix.packages.${system}.bazel_4;
              tmux-base = oh-my-tmux;
              neovim-nightly = neovim-src.packages.${system}.neovim;
              neovim-unwrapped = neovim-src.packages.${system}.neovim;

              master = nixpkgs-master.legacyPackages.${system};
              stable = nixpkgs-stable.legacyPackages.${system};

              # Install colorscheme via input so it just works
              vimPlugins = prev.vimPlugins // {
                codedark = prev.vimUtils.buildVimPluginFrom2Nix {
                  pname = "vim-code-dark";
                  version = inputs.codedark.lastModifiedDate;
                  src = inputs.codedark;
                };

                # nvim-treesitter = prev.vimPlugins.nvim-treesitter.overrideAttrs (old: {
                #   version = inputs.nvim-tree-sitter.lastModifiedDate;
                #   src = inputs.nvim-tree-sitter;
                # });
              };

              tmux-darwin = prev.runCommand prev.tmux.name
                { buildInputs = [ prev.makeWrapper ]; }
                ''
                  source $stdenv/setup
                  mkdir -p $out/bin
                  makeWrapper ${prev.tmux}/bin/tmux $out/bin/tmux \
                    --set __ETC_BASHRC_SOURCED "" \
                    --set __ETC_ZPROFILE_SOURCED  "" \
                    --set __ETC_ZSHENV_SOURCED "" \
                    --set __ETC_ZSHRC_SOURCED "" \
                    --set __NIX_DARWIN_SET_ENVIRONMENT_DONE ""
                '';

              spicetify-cli = prev.spicetify-cli.overrideAttrs (old: {
                # TODO: Add in job to update tag https://github.com/khanhas/spicetify-cli/releases
                version = "2.9.0";
                src = spicetify;
              });

              # "wezterm_nvim" = prev.buildGoModule {
              #   pname = "wezterm.nvim";
              #   version = "0.0.1";
              #   src = wezterm-nvim;
              #   vendorSha256 = "sha256-ZmVi9sitr62uQqPCoxmkABZ6frSUaUI1nOd4mPJs4x0=";
              #   subPackages = [ "wezterm.nvim.navigator" ];
              # };
            }
        )
      ];

      nixpkgsConfig = with inputs; {
        config = { allowUnfree = true; };
        inherit overlays;
      };

      homeManagerCommonConfig = with self; {
        imports = [
          ./home/home.nix
        ];
      };

      # Modules shared by most `nix-darwin` personal configurations.
      nixDarwinCommonModules = { user }: [
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          users.users.${user}.home = "/Users/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = homeManagerCommonConfig;
        }
      ];
    in
    {
      defaultTemplate = {
        path = ./template;
        description = "nix flake new -t github:jacobfoard/dotfiles .";
      };

      defaultIso = self.nixosConfigurations.defaultIso.config.system.build.isoImage;
      linodeIso = self.nixosConfigurations.linodeIso.config.system.build.isoImage;

      darwinConfigurations = {
        # darwin requires an inital bootstrapping
        bootstrap = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./darwin/bootstrap.nix
            {
              nixpkgs = nixpkgsConfig;
            }
          ];
        };

        bootstrapM1 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/bootstrap.nix
            {
              nixpkgs = nixpkgsConfig;
            }
          ];
        };

        Wozniak = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
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

        Lovelace = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = nixDarwinCommonModules { user = "jacobfoard"; } ++ [
            ./machines/lovelace/configuration.nix
            {
              # I don't love the name but not my choice
              networking.computerName = "MLM1-MBP16-Jacob";
              networking.hostName = "Lovelace";
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
        pkgs = import nixpkgs {
          inherit system;
          # inherit overlays;
        };
        stable-pkgs = if system == "x86_64-darwin" then inputs.nixpkgs-stable-darwin else inputs.nixos-stable;
        stable = stable-pkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            # cachix
            tree
            ncurses
            statix
            nix-linter
            stylua
          ];
        };
      }
    );
}
