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
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
    ];


    extraConfig = ''
      lua << EOF
       require("boot")
      EOF
    '';

    extraPackages = with pkgs; [
      # neovim-remote

      # needed for tree-sitter
      gcc
      libcxx
      tree-sitter
      nodejs

      # Lua Formatter
      stylua

      gnumake

      # Language servers
      # TODO: This doesn't work on darwin, but probably could with some effort
      # omnisharp-roslyn

      # mono
      # dotnet-sdk_5
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.vim-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      nodePackages.diagnostic-languageserver
      rnix-lsp
      rust-analyzer
      rustfmt
      statix
      sumneko-lua-language-server
    ];
  };

  xdg.configFile."nvim/lua".source = ../config/nvim/lua;
  # Can't use this right now so it is symlinked to lua/boot.lua 
  # and referenced by init.vim
  # xdg.configFile."nvim/init.lua".source = ../config/nvim/init.lua;
  xdg.configFile."nvim/init.vim".text =
    ''
      set termguicolors
    '';

  # Semi-vim related so I stuck this here
  home.file.".ideavimrc".source = ../config/jetbrains/ideavimrc;
}




