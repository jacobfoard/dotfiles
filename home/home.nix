{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./ssh.nix
    ./zsh.nix
  ];

  home.username = "jacobfoard";
  home.homeDirectory = "/Users/jacobfoard";

  programs = {
    bat.enable = true;

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    htop = {
      enable = true;
      settings.show_program_path = true;
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        local init = require("init");
        return init;
      '';
    };
  };

  home.packages = with pkgs; [
    coreutils
    curl
    du-dust # fancy du
    lsd # fancy ls
    parallel
    procs
    fd
    ripgrep
    termshark
    unzip
    wget
    gnused
    procps # includes watch
    jq
    yq-go
    nixpkgs-fmt
  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    bazel
    (google-cloud-sdk.withExtraComponents
      ([pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin]))
    krew
    kubectx
    kubernetes-helm
    kubectl
    kubetail
    istioctl
    go_1_21
    gopls
    golangci-lint
    # Some things want gnused to be install via brew, which leads to "gsed"
    (writeShellScriptBin "gsed" ''${pkgs.gnused}/bin/sed $@'')
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

}
