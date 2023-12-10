{ pkgs, inputs, ... }:

{
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = [ "jacobfoard" ];
    };

    zsh.enable = true;
  };

  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      recursive
      (nerdfonts.override { fonts = [ "JetBrainsMono" "VictorMono" ]; })
    ];
  };

  nixpkgs.config.allowUnfree = true;

  users.users.jacobfoard = {
    isNormalUser = true;
    description = "Jacob";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword = "$6$0RSKkJrVnzxeD5ie$iia4XxKbx58cGlQUEhVnVbBc94acRd8OIgDX2LmWZkKoPj4XAExw3XeYmntRT077hMCOz09LrFW0e//sRA5m71";
  };
}
