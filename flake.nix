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
      # url = "github:LnL7/nix-darwin";
      url = "github:jacobfoard/nix-darwin/waiting-on-upstream";
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

    codedark = {
      url = "github:jacobfoard/vim-code-dark/personal-changes";
      flake = false;
    };

    thefuck = {
      url = "github:nvbn/thefuck?ref=3.30";
      flake = false;
    };

    oh-my-tmux = {
      url = "github:gpakosz/.tmux";
      flake = false;
    };

    spicetify = {
      # TODO: Add in job to update tag https://github.com/khanhas/spicetify-cli/releases
      url = "github:khanhas/spicetify-cli?ref=v2.8.3";
      flake = false;
    };

    mango = {
      url = "git+ssh://git@github.com/greenpark/mango.git?ref=main";
      inputs.phoenix.follows = "phoenix";
    };

    phoenix.url = "git+ssh://git@github.com/greenpark/phoenix.git?ref=main";
  };


  outputs = { self, nixpkgs, nixos, darwin, home-manager, flake-utils, mango, phoenix, ... }@inputs:
    let
      overlays = with inputs; [
        neovim-nightly-overlay.overlay
        (
          final: prev:
            let
              inherit (prev.stdenv) system;
              nixpkgs-stable = if system == "x86_64-darwin" then nixpkgs-stable-darwin else nixos-stable;
            in
            rec {
              mango_gpsd = mango.defaultPackage.${system};
              inherit (phoenix.packages.${system}) golines;
              graphite = phoenix.packages.${system}.graphite-cli;
              tmux-base = oh-my-tmux;

              master = nixpkgs-master.legacyPackages.${system};
              stable = nixpkgs-stable.legacyPackages.${system};

              # Temporaray overides for packages we use that are currently broken on `unstable`
              thefuck = prev.thefuck.overrideAttrs (old: {
                src = inputs.thefuck;
                version = "3.30";
                doInstallCheck = false;
              });

              # Install colorscheme via input so it just works
              vimPlugins = prev.vimPlugins // {
                codedark = prev.vimUtils.buildVimPluginFrom2Nix {
                  pname = "vim-code-dark";
                  version = inputs.codedark.lastModifiedDate;
                  src = inputs.codedark;
                };
              };

              # Check in on https://github.com/NixOS/nixpkgs/pull/146456 to see if it can be removed
              google-cloud-sdk = prev.google-cloud-sdk.overrideAttrs (old: {
                postInstall = ''
                  sed -i '1 i #compdef gcloud' $out/share/zsh/site-functions/_gcloud
                  sed -i '1 i #compdef gsutil' $out/share/zsh/site-functions/_gsutil
                '';
              });

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
                version = "2.8.3";
                src = spicetify;
              });

              bazel_4 = prev.bazel_4.overrideAttrs (old: rec {
                system = if prev.stdenv.hostPlatform.isDarwin then "darwin" else "linux";
                arch = prev.stdenv.hostPlatform.parsed.cpu.name;

                installPhase = old.installPhase +
                  (if prev.stdenv.hostPlatform.isDarwin && prev.stdenv.hostPlatform.isAarch64 then
                    ''
                      mv $out/bin/bazel-${old.version}-${system}-${arch} $out/bin/bazel-${old.version}-${system}-arm64 
                    ''
                  else "");
              });

              sumneko-lua-language-server = prev.sumneko-lua-language-server.overrideAttrs (old: rec {
                version = "2.5.6";
                src = prev.fetchFromGitHub {
                  owner = "sumneko";
                  repo = "lua-language-server";
                  rev = version;
                  sha256 = "sha256-dSj3wNbQghiGfqe7dNDbWnbXYLSiG+0mYv2yFmGsAc8=";
                  fetchSubmodules = true;
                };
                installPhase = ''
                  runHook preInstall

                  install -Dt "$out"/share/lua-language-server/bin bin/lua-language-server
                  install -m644 -t "$out"/share/lua-language-server/bin bin/*.*
                  install -m644 -t "$out"/share/lua-language-server {debugger,main}.lua
                  cp -r locale meta script "$out"/share/lua-language-server

                  # necessary for --version to work:
                  install -m644 -t "$out"/share/lua-language-server changelog.md

                  makeWrapper "$out"/share/lua-language-server/bin/lua-language-server \
                    $out/bin/lua-language-server \
                    --add-flags "-E $out/share/lua-language-server/main.lua \
                    --logpath='~/.cache/sumneko_lua/log' \
                    --metapath='~/.cache/sumneko_lua/meta'"

                  runHook postInstall

                '';
              });
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
              networking.computerName = "Jacob’s 💻";
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
            cachix
            tree
            ncurses
            statix
            nix-linter
          ];
        };
      }
    );
}
