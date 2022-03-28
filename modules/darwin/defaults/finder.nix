{ config, lib, ... }:

with lib;

{
  options = {
    system.defaults.finder.ShowPreviewPane = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };

    system.defaults.finder.ShowRecentTags = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };
  };
}
