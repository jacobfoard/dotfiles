{ config, lib, ... }:

with lib;

{
  options = {
    system.defaults.finder.AppleShowAllFiles = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };

    system.defaults.finder.ShowPreviewPane = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };

    system.defaults.finder.ShowRecentTags = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };

    system.defaults.finder.ShowStatusBar = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };
  };
}
