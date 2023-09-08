{ config, pkgs, lib, ... }:

{
  imports = [
    ../modules/nix.nix
  ];


  # Shells -----------------------------------------------------------------------------------------
  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    zsh
    bash
  ];

  services.nix-daemon.enable = true;
  nix.configureBuildUsers = true;

  # Install and setup ZSH to work with nix(-darwin) as well
  programs.zsh.enable = true;
  programs.bash.enable = true; # default shell on catalina

  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enableCompletion = false;
  documentation.enable = false;

  system.activationScripts.postActivation.text = ''
    ${pkgs.nix}/bin/nix store \
     --experimental-features 'nix-command' \
     diff-closures /run/current-system "$systemConfig"

    read -p "Run nix-collect-garbage? [y/N]: " COLLECT_GARBAGE

    case $COLLECT_GARBAGE in
      [Yy]*) sudo nix-collect-garbage -d;;
    esac
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
