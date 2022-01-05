{
  homebrew = {

    enable = true;
    brewPrefix = "/opt/homebrew/bin";
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
      Amphetamine = 937984704;
      Clocker = 1056643111;
      Tailscale = 1475387142;
      Xcode = 497799835;
    };

    casks = [
      "1password"
      "1password-cli"
      "bettertouchtool"
      "camo-studio"
      "element"
      "firefox"
      "docker"
      "itsycal"
      "iterm2"
      "jetbrains-toolbox"
      "raycast"
      "rectangle"
      "slack"
      "spotify"
      "spotmenu"
      "unity-hub"
      "yubico-yubikey-manager"
      "yubico-yubikey-personalization-gui"
    ];

    brews = [
      "mongodb-community-shell"
      "pam_reattach"
    ];
  };
}
