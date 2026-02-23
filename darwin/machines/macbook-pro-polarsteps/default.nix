{
  config,
  pkgs,
  username,
  ...
}:
{
  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
    onActivation.autoUpdate = true;

    casks = [
      "1password"
      "1password-cli"
      "claude-code"
      "dbeaver-community"
      "firefox"
      "itsycal"
      "orbstack"
      "raycast"
      "rectangle"
      "slack"
      "spotify"
    ];

    masApps = {
      Amphetamine = 937984704;
      Clocker = 1056643111;
      Xcode = 497799835;
    };

    brews = [
    ];
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  # Network configuration
  networking = {
    knownNetworkServices = [
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };

  # User configuration
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  # System packages for this machine (work-related tools)
  environment.systemPackages = with pkgs; [
    fastlane
    krew
    kubectx
    kubernetes-helm
    kubectl
    kubetail
    awscli2
    vault
    # argocd # TODO: broken upstream -- UI build missing git in nativeBuildInputs
    k9s
    cmctl
    argo-rollouts
    eks-node-viewer
    ssm-session-manager-plugin
    # MCP servers from mcp-servers-nix overlay
    mcp-server-memory
    # context7-mcp
    mcp-server-sequential-thinking
    #  serena
    # Custom packages from pkgs overlay
    cozempic
    kubectl-cnpg
    beads
    entire-cli
    # gastown # TODO: disabled until sandbox build fixed
    kubectl-evict-pod
    postgresql
    hey
    dive
    terramate
    uv
    python314
  ];
}
