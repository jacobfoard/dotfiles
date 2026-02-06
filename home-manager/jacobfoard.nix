{ ... }:

{ pkgs, ... }:

{
  imports = [
    # inputs.nixvim.homeManagerModules.nixvim
    ./claude.nix
    ./git.nix
    ./neovim.nix
    ./zsh.nix
    ./packages.nix
    ./programs.nix
    ./xdg.nix
  ];

  # nix.package = pkgs.nix;

  # nix.settings.trusted-users = [
  #   "root"
  #   currentSystemUser
  # ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
}
