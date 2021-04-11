{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos.nix
    ];

  # age.secrets.book.file = ../../config/fonts/operator_mono/Operator_Mono_SSm_Lig_Book_Nerd_Font_Complete.otf.age;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "cerf";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp3s0.useDHCP = true;
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Enable the GNOME 3 Desktop Environment.
    desktopManager.gnome3.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "jacobfoard";
      };
      gdm.enable = true;
      gdm.wayland = false;
    };
  };

  # Allow VNC via GNOME Remote Desktop
  services.gnome3.gnome-remote-desktop.enable = true;
  networking.firewall.allowedTCPPorts = [ 5900 ];

  # Disable sleeping for this box as it'll be used via ssh most of the time
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  fileSystems."/nas" =
    {
      device = "10.0.0.10:/volume1/NAS";
      fsType = "nfs";
    };

  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users.jacobfoard = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMawRAUvEutC1cMS0IXQoKh7UqIK2Yh0V+ODjNLYFfxh cardno:000616401000"
      ];
    };
  };
  security.sudo.extraRules = [
    {
      users = [ "jacobfoard" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    wget
    firefox
    qemu_kvm
    libvirt
    xorg.xhost
    pcsclite
    pinentry-curses
    pinentry-qt
  ];

  services = {
    tailscale.enable = true;
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    openssh = {
      enable = true;
      extraConfig =
        ''
          StreamLocalBindUnlink yes
          AcceptEnv LANG LC_* IS_REMOTE
        '';
    };
    synergy.client = {
      enable = false;
      # serverAddress = "10.0.0.39";
      serverAddress = "10.0.0.249";
    };
  };


  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

