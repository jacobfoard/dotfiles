{ inputs, ... }:

{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./git.nix
    ./neovim.nix
    ./zsh.nix
  ];

  xdg.enable = true;

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
    watch
    jq
    yq-go
    nixpkgs-fmt

    # Node is required for Copilot.vim
    nodejs
  ] ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
    cachix
    tailscale
    (writeShellScriptBin "gsed" ''${pkgs.gnused}/bin/sed $@'')
  ]) ++ (lib.optionals isLinux [
    firefox
    gopls
    delve
    go-tools
  ]);

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

    vscode = {
      enable = true;
      extensions = with pkgs; [
        vscode-extensions.jnoortheen.nix-ide
        vscode-extensions.golang.go
        vscode-extensions.github.copilot
        vscode-extensions.github.copilot-chat

      ];
    };

    ssh = {
      enable = true;
      forwardAgent = true;
      extraConfig = ''
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
      # matchBlocks = {
      # "*" = {
      # extraOptions = lib.optionals isLinux {
      #   IdentityAgent = "~/.1password/agent.sock";
      # };

      # extraOptions = lib.optionals isDarwin {
      #   IdentityAgent = """\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"""";
      # };
      # };
      # };
    };
  };

  # TODO: Figure out how to do this better
  xdg.configFile."wezterm/colors.lua".source = ./wezterm/colors.lua;
  xdg.configFile."wezterm/init.lua".source = ./wezterm/init.lua;
  xdg.configFile."wezterm/keys.lua".source = ./wezterm/keys.lua;
  xdg.configFile."wezterm/mouse.lua".source = ./wezterm/mouse.lua;
  xdg.configFile."wezterm/status-line.lua".source = ./wezterm/status-line.lua;
  xdg.configFile."nvim/lua/statusline.lua".source = ./neovim/statusline.lua;


  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
}
