{
  homebrew = {

    enable = true;
    autoUpdate = true;
    cleanup = "zap";
    global.brewfile = true;
    global.noLock = true;

    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "fabianishere/personal"
      "mongodb/brew"
    ];

    masApps = {
      "1Password" = 1333542190;
      Clocker = 1056643111;
      Slack = 803453959;
      Tailscale = 1475387142;
      Xcode = 497799835;
    };

    casks = [
      "bettertouchtool"
      "element"
      "firefox"
      "docker"
      "itsycal"
      "iterm2"
      "rectangle"
      "spotify"
      "spotmenu"
      "unity-hub"
      "yubico-yubikey-manager"
      "yubico-yubikey-personalization-gui"
    ];

    brews = [
      "mongodb-community-shell"
      "pam_reattach"
      "pulumi"
      "watch"
    ];
  };
}
