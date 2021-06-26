{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf;
  nvr = "${pkgs.neovim-remote}/bin/nvr";

in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    withRuby = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      packer-nvim
      codedark
    ];


    extraConfig = ''
      lua << EOF
       require("boot")
      EOF
    '';

    extraPackages = with pkgs; [
      neovim-remote
      gcc # needed for tree-sitter
      # this also needs some sort of node access for 
      # tree-sitter generate 
      tree-sitter

      # needed for iamcco/markdown-preview.nvim
      nodejs
      yarn

      # Language servers
      # TODO: This doesn't work on darwin, but probably could with some effort
      # omnisharp-roslyn
      mono
      dotnet-sdk_5
      nodePackages.bash-language-server
      nodePackages.typescript-server
      nodePackages.vim-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      nodePackages.diagnostic-languageserver
      rnix-lsp
      rust-analyzer
    ] ++ lib.optional (!stdenv.isDarwin) sumneko-lua-language-server;
  };

  xdg.configFile."nvim/lua".source = ../config/nvim/lua;
  # Can't use this right now so it is symlinked to lua/boot.lua 
  # and referenced by init.vim
  # xdg.configFile."nvim/init.lua".source = ../config/nvim/init.lua;
  xdg.configFile."nvim/init.vim".text =
    ''
      set termguicolors
    '';
}




