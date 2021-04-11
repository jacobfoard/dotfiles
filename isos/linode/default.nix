{ config, lib, pkgs, ... }:
with lib; {

  imports = [
    ../general
  ];

  # https://www.linode.com/docs/guides/install-nixos-on-linode/#enable-lish
  boot.kernelParams = [ "console=ttyS0,19200n8" ];

  environment.systemPackages = with pkgs; [
    inetutils
    mtr
    sysstat
    python39
  ];
}

