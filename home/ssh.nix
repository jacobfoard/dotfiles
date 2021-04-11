{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;

    forwardAgent = true;
    matchBlocks = {
      "*" = {
        extraOptions = {
          IdentityAgent = "~/.gnupg/S.gpg-agent.ssh";
        };
      };
    };
  };
}
