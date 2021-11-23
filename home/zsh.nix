{ config, pkgs, ... }:

{
  config = {
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = false;
      enableSyntaxHighlighting = true;
      autocd = true;

      history = {
        expireDuplicatesFirst = true;
        save = 10000000;
        size = 10000000;
      };

      shellAliases = {
        cat = "bat";
        ls = "lsd";
        du = "dust";
        ps = "procs";
        "clean-up-git-branches-force" = "git branch -vv | grep origin | grep gone | awk '{print \$1}'|xargs -L 1 git branch -D";
        "clean-up-git-branches" = "git branch -vv | grep origin | grep gone | awk '{print \$1}'|xargs -L 1 git branch -d";
        "clean-up-sqaush-main" = ''git checkout -q main && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base main $branch) && [[ $(git cherry main $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'';
        "clean-up-sqaush-dev" = ''git checkout -q development && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base development $branch) && [[ $(git cherry development $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'';
        copy = ''tr -d "\n" | pbcopy'';
        gca = "git commit --amend --no-edit";
        gssh = "TERM=xterm-256color gcloud compute ssh --tunnel-through-iap";
        k = "kubectl";
        kc = "kubectx";
        kt = "kubetail";
        kns = "kubens";
        mkdir = "mkdir -p";
        proj = "gcloud config configurations activate";
        r = "cd `git rev-parse --show-toplevel`";
        dots = "~/code/gitlab.com/jacobfoard/dotfiles";
        jf = "~/code/github.com/jacobfoard";
        gmi = "pwd | sed 's;.*code/;;' | xargs go mod init";
        gl = "~/code/gitlab.com";
      };

      initExtraFirst = builtins.readFile ../config/zsh/initExtraFirst.zsh;
      initExtra = builtins.readFile ../config/zsh/initExtra.zsh;

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.stable.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          # I don't understand this one, but it works
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
      ];

      oh-my-zsh = {
        enable = true;
        plugins = [
          "gitfast"
          "kubectl"
          "docker"
          "gitignore"
          "golang"
          "git-auto-fetch"
        ];
      };
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    xdg.configFile."zsh/p10k.zsh".source = ../config/zsh/p10k.zsh;
  };
}

