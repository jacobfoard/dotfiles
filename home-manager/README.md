# home-manager configurations

Single home-manager surface with one module and a quick apply helper.

## Outputs
- `homeModules.default` – single module (nixos/darwin)
- `homeConfigurations.jacobfoard` – standalone config for the current system
- `apps.<system>.setup` – `nix run .#setup` to switch the home config
- `devShells.<system>.default` – shell with the home-manager CLI available

## Integrated use (nixos or darwin)

Add the module to your system home-manager user:

```nix
{ inputs, ... }: {
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  home-manager.users.jacobfoard = {
    imports = [ inputs.home.homeModules.default ];
    # home.username/home.homeDirectory will come from the flake wrapper
  };
}
```

## Quick apply on a fresh machine

Either run the app wrapper or call home-manager directly:

```bash
nix run .#setup           # uses the bundled home-manager
home-manager switch --flake .#jacobfoard
```

The module lives in [v7/home-manager/jacobfoard.nix](v7/home-manager/jacobfoard.nix) and pulls smaller pieces from [v7/home-manager/packages.nix](v7/home-manager/packages.nix), [v7/home-manager/programs.nix](v7/home-manager/programs.nix), [v7/home-manager/xdg.nix](v7/home-manager/xdg.nix), plus git/neovim/zsh modules.
