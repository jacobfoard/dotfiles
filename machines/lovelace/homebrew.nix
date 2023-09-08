{
  homebrew = {

    enable = false;
    brewPrefix = "/opt/homebrew/bin";
    # onActivation.cleanup = "zap";
    global.autoUpdate = true;
    global.brewfile = true;
    global.lockfiles = true;

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
      Trello = 1278508951;
      # Xcode = 497799835;
    };

    casks = [
      # "1password"
      # "1password-cli"
      "bettertouchtool"
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
      "mongodb-database-tools"
      "pam_reattach"
      "mongosh"
    ];
  };
}
