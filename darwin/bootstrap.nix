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
  users.nix.configureBuildUsers = true;

  # Install and setup ZSH to work with nix(-darwin) as well
  programs.zsh.enable = true;
  programs.bash.enable = true; # default shell on catalina

  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enableCompletion = false;

  system.activationScripts.postActivation.text = ''
    ${pkgs.nixUnstable}/bin/nix store \
     --experimental-features 'nix-command' \
     diff-closures /run/current-system "$systemConfig"
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
