{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf;
  nvr = "${pkgs.neovim-remote}/bin/nvr";

in
{
  programs.neovim = {
    enable = true;
    # package = pkgs.neovim-nightly;
    withRuby = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      packer-nvim
      codedark
      (pkgs.stable.vimPlugins.nvim-treesitter.withPlugins (plugins: pkgs.stable.tree-sitter.allGrammars))
      # (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
    ];


    # extraConfig = ''
      # set termguicolors
      # let g:do_filetype_lua = 1
      # let g:did_load_filetypes = 0
      # autocmd BufNewFile,BufRead *.json setlocal filetype=jsonc
      #
      # lua << EOF
      #  require("boot")
      # EOF
    # '';

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
      omnisharp-roslyn

      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.vim-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      nodePackages.diagnostic-languageserver
      gopls
      rnix-lsp
      rust-analyzer
      rustfmt
      statix
      sumneko-lua-language-server
      # zls
    ];
  };

  # xdg.configFile."nvim/lua".source = ../config/nvim/lua;
  # Can't use this right now so it is symlinked to lua/boot.lua 
  # and referenced by init.vim
  # xdg.configFile."nvim/init.lua".source = ../config/nvim/init.lua;
  # xdg.configFile."nvim/init.vim".text =
  #   ''
  #   '';
  # https://neovim.discourse.group/t/introducing-filetype-lua-and-a-call-for-help/1806

  # Semi-vim related so I stuck this here
  home.file.".ideavimrc".source = ../config/jetbrains/ideavimrc;
}




