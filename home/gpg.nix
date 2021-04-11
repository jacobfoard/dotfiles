{ config, pkgs, lib, ... }:

{
  services.gpg-agent = {
    # enable = true;
    # enableSshSupport = true;
    # enableExtraSocket = true;
    defaultCacheTtl = 34560000;
    defaultCacheTtlSsh = 34560000;
    maxCacheTtl = 34560000;
    maxCacheTtlSsh = 34560000;
    pinentryFlavor = "curses";
  };

  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = true;
    };
    #         reader-port = "Yubico Yubi";
    # settings = {
    #   "pinentry-program" = "/run/current-system/sw/bin/pinentry-curses";
    # };
  };
}
