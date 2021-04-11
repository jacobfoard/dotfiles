{ config, pkgs, lib, ... }:

{
  users.users.jacobfoard.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMawRAUvEutC1cMS0IXQoKh7UqIK2Yh0V+ODjNLYFfxh cardno:000616401000"
  ];
}
