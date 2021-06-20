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
      cerf = {
        hostname = "10.0.0.36";
        extraOptions = {
          SetEnv = "IS_REMOTE=true";
        };
      };
      cohen = {
        hostname = "10.0.0.11";
        user = "root";
      };
    };
  };
}
