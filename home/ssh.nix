{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;

    forwardAgent = true;
    matchBlocks = {
      "*" = {
        extraOptions = {
          # IdentityAgent = "~/.gnupg/S.gpg-agent.ssh";
           IdentityAgent = "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
        };
      };
      # cerf = {
      #   hostname = "10.0.0.36";
      #   extraOptions = {
      #     SetEnv = "IS_REMOTE=true";
      #   };
      # };
      # cohen = {
      #   hostname = "10.0.0.11";
      #   user = "root";
      # };
    };
  };
}
