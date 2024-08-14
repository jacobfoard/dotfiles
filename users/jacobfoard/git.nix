{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      git-lfs
      gitAndTools.delta
      gitAndTools.gh
      gitAndTools.glab
      gitAndTools.git-filter-repo
      (writeShellScriptBin "git-browse" (builtins.readFile ../../bin/git-browse))
    ];

    programs.git = {
      enable = true;

      userName = "Jacob Foard";
      userEmail = "jacobfoard@gmail.com";

      ignores = [
        ".direnv"
        "result"
        ".DS_Store"
        ".idea"
      ];

      delta.enable = true;

      extraConfig = {
        help.autoCorrect = "prompt";

        delta.features = "side-by-side line-numbers decorations";
        url = {
          "ssh://git@github.com/" = { insteadOf = "https://github.com/"; };
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


        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8VqP8fIx2fITGkSURLDUT0ZpbK8lP/Rje49a3p2XId";
        gpg = {
          format = "ssh";
          ssh = {
            # program = "op-ssh-sign"; # TODO: Check if this works on darwin
            program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          };
        };

        commit.gpgsign = true;

        "filter \"lfs\"" = {
          process = "git-lfs filter-process";
          required = true;
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
        };
      };
    };
  };
}
