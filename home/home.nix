{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./gpg.nix
    ./neovim.nix
    ./ssh.nix
    ./tmux.nix
    ./zsh.nix
  ];

  programs = {
    bat.enable = true;

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
      # # Check in on to see if this can be removed 
      # # https://github.com/nix-community/nix-direnv/issues/120
      # stdlib = ''
      #   sed() { ${pkgs.gnused}/bin/sed "$@"; }
      # '';
    };

    htop = {
      enable = true;
      settings.show_program_path = true;
    };

  };


  # xdg.configFile.wezterm.source = ../config/wezterm;

  home.sessionVariables = {
    EDITOR = "nvim";
  };


  home.packages = with pkgs; [
    # Some basics
    bandwhich # fails on bootstraping
    coreutils
    curl
    du-dust # fancy version of `du`
    lsd # fancy version of `ls`
    htop
    parallel
    procs # fancy version of `ps`
    fd
    ripgrep
    telnet
    termshark
    thefuck
    gnupg
    unzip
    wget
    gnused
    procps # Provides watch
    youtube-dl

    python3
    python3.pkgs.pyyaml
    # wezterm

    google-cloud-sdk
    jq
    yq
    go_1_17
    atuin

    # wezterm_nvim

    nixpkgs-fmt
  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    bazel_4

    # Some things want gnused to be install via brew, which leads to "gsed"
    (writeShellScriptBin "gsed" ''${pkgs.gnused}/bin/sed $@'')
  ] ++ lib.optionals stdenv.isLinux [ ];

  # This value determines the Home Manager release that your configuration is compatible with. This
  # helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.
  #
  # You can update Home Manager without changing this value. See the Home Manager release notes for
  # a list of state version changes in each release.
  home.stateVersion = "21.03";
}

