{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      git-lfs
      delta
      gh
      (writeShellScriptBin "git-browse" (builtins.readFile ./bin/git-browse))
    ];

    programs.git = {
      enable = true;

      ignores = [
        ".direnv"
        "result"
        ".DS_Store"
        ".idea"
      ];

      signing = {
        format = "ssh";
        # key = "~/.ssh/id_ed25519.pub";
        signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        signByDefault = true;
      };

      settings = {
        help.autoCorrect = "prompt";

        delta.features = "side-by-side line-numbers decorations";
        url = {
          "ssh://git@github.com/" = {
            insteadOf = "https://github.com/";
          };
        };

        merge.conflictStyle = "diff3";

        init.defaultBranch = "main";
        advice.detachedHead = false;

        fetch.prune = true;
        pull.rebase = true;

        push.autoSetupRemote = true;

        rebase.autoStash = true;
        rebase.instructionFormat = "(%an <%ae>) %s";

        github.user = "jacobfoard";

        user.name = "Jacob Foard";
        user.email = "jacobfoard@gmail.com";
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8VqP8fIx2fITGkSURLDUT0ZpbK8lP/Rje49a3p2XId";
        # gpg = {
        # format = "ssh";
        # ssh = {
        # program = "op-ssh-sign"; # TODO: Check if this works on darwin
        # program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        # };
        # };

        commit.gpgsign = true;

        "filter \"lfs\"" = {
          process = "git-lfs filter-process";
          required = true;
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
        };
      };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
