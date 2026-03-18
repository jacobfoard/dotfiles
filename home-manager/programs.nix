{ config, pkgs, ... }:

{
  config = {
    programs = {
      atuin = {
        enable = true;
        enableZshIntegration = true;
        flags = [ "--disable-up-arrow" ];
      };

      bat.enable = true;
      # home-manager.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      htop = {
        enable = true;
        settings.show_program_path = true;
      };

      jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Jacob Foard";
            email = "jacobfoard@gmail.com";
          };

          signing = {
            backend = "ssh";
            key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8VqP8fIx2fITGkSURLDUT0ZpbK8lP/Rje49a3p2XId";
            sign-all = true;
            backends.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          };

          # Make jj use delta for diffs
          # https://github.com/jj-vcs/jj/discussions/4690#discussioncomment-13902914
          diff.tool = "delta";

          ui = {
            diff-formatter = ":git";
            pager = [
              "delta"
              "--pager"
              "less -FRX"
            ];
          };
          "--scope" = [
            {
              "--when.commands" = [
                "diff"
                "show"
              ];
            }
          ];
          "--scope.ui".pager = [ "delta" ];
        };
      };

      wezterm = {
        enable = true;
        extraConfig = ''
          local init = require("init");
          return init;
        '';
      };

      ssh = {
        enable = true;
        enableDefaultConfig = false;
        extraConfig = ''
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        '';
        matchBlocks."*".forwardAgent = true;
      };
    };
  };
}
