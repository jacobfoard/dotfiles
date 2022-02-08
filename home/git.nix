{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      git-lfs
      gitAndTools.delta
      gitAndTools.gh
      gitAndTools.glab
      gitAndTools.git-filter-repo
      (writeShellScriptBin "git-browse" (builtins.readFile ../bin/git-browse))
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
        rebase.autoStash = true;

        commit.gpgsign = true;
        gpg.program = "${pkgs.gnupg}/bin/gpg2";

        signing = {
          signByDefault = true;
          key = "0xC02488F487CF438C";
          gpgPath = "gpg";
        };

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

