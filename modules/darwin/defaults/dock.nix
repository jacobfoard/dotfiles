{ config, lib, ... }:

with lib;

{
  options = {
    system.defaults.dock.largesize = mkOption {
      type = types.nullOr types.int;
      default = null;
    };

    system.defaults.dock.magnification = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };
  };
}
