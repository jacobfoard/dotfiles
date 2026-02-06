{ pkgs, ... }:
let
  treesitterWithGrammars = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    # Common
    p.bash
    p.comment
    p.go
    p.gomod
    p.gowork
    p.json
    p.json5
    p.jq
    p.lua
    p.make
    p.markdown
    p.nix
    p.python
    p.rust
    p.typescript
    p.yaml
    p.vim
    # Web
    p.css
    p.html
    p.javascript
    p.tsx
    p.vue
    # DevOps
    p.dockerfile
    p.hcl
    p.terraform
    p.toml
    # Git
    p.gitattributes
    p.gitignore
  ]);

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };
in
{
  home.packages = with pkgs; [
    # Search/find tools
    ripgrep
    fd

    # LSP servers
    lua-language-server
    gopls
    rust-analyzer
    nil # nix LSP
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    pyright

    # Formatters/linters
    stylua
    nixfmt
    prettierd
    black

    # Other
    nodejs_22
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    plugins = [ treesitterWithGrammars ];
  };

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };

  # Generated init for jacob namespace with treesitter path
  xdg.configFile."nvim/lua/jacob/init.lua".text = ''
    vim.opt.runtimepath:append("${treesitter-parsers}")
  '';
}
