_:

{
  imports = [
    ../../modules/darwin/defaults/finder.nix
    # TODO Make these actual options instead of just appending the defaults writes
    ../../modules/darwin/defaults/bettertouchtool.nix
    ../../modules/darwin/defaults/clock.nix
    ../../modules/darwin/defaults/touchbar.nix
    ../../modules/darwin/defaults/itsycal.nix
    ../../modules/darwin/defaults/rectangle.nix
  ];

  system.defaults.NSGlobalDomain = {
    "com.apple.swipescrolldirection" = false;
    AppleShowScrollBars = "Automatic";
    # This is the weird char popup thing
    ApplePressAndHoldEnabled = false;
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
  };

  # Dock and Mission Control
  system.defaults.dock = {
    largesize = 100;
    tilesize = 50;
    show-recents = false;
    magnification = true;
  };


  # TODO Figure out how to set ~/Library/Preferences/com.apple.symbolichotkeys.plist
  system.keyboard = {
    enableKeyMapping = true;
    # Works fine on desktop, need to figure out how to only set for non-macbook keyboard
    swapLeftCommandAndLeftAlt = false;
  };


  # Finder
  system.defaults.finder = {
    FXEnableExtensionChangeWarning = false;
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    ShowPreviewPane = true;
    ShowRecentTags = false;
    ShowStatusBar = true;
  };
}
