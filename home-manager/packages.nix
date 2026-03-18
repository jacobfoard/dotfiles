{
  config,
  lib,
  pkgs,
  ...
}:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.packages =
    with pkgs;
    [
      coreutils
      inetutils
      curl
      dust
      lsd
      # parallel
      procs
      fd
      ripgrep
      # termshark
      # unzip
      wget
      gnused
      watch
      jq
      yq-go
      av
      home-manager
      # nixpkgs-fmt
      # nixfmt-rfc-style

      # jjui

      attic-client

      # Node is required for Copilot.vim
      # nodejs
    ]
    ++ (lib.optionals isDarwin [
      # This is automatically setup on Linux
      # cachix
      # tailscale
      yaml-language-server
      helm-ls
      (writeShellScriptBin "gsed" ''${pkgs.gnused}/bin/sed "$@"'')
      # tmux
    ])
    ++ (lib.optionals isLinux [
      # firefox
      # gopls
      # delve
      # go-tools
    ]);
}
