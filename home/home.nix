{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./gpg.nix
    ./neovim.nix
    ./ssh.nix
    ./zsh.nix
  ];

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

    # tmux.extraConfig = builtins.readFile ../config/tmux/tmux.conf;

  };


  # xdg.configFile.wezterm.source = ../config/wezterm;



  home.sessionVariables = {
    EDITOR = "nvim";
  };


  home.packages = with pkgs; [
    # Some basics
    # bandwhich # fails on bootstraping
    coreutils
    curl
    du-dust # fancy version of `du`
    lsd # fancy version of `ls`
    htop
    parallel
    procs # fancy version of `ps`
    ripgrep
    telnet
    termshark
    thefuck
    tmux
    gnupg
    unzip
    wget
    yubikey-manager
    youtube-dl

    python3
    python3.pkgs.pyyaml
    # wezterm

    google-cloud-sdk
    jq
    yq
    go

    nixpkgs-fmt
  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    m-cli # useful macOS CLI commands
    bazel_4
  ] ++ lib.optionals stdenv.isLinux [ ];

  # This value determines the Home Manager release that your configuration is compatible with. This
  # helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.
  #
  # You can update Home Manager without changing this value. See the Home Manager release notes for
  # a list of state version changes in each release.
  home.stateVersion = "21.03";
}

