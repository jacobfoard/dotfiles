# home-manager configurations

Single home-manager surface with one module and a quick apply helper.

## Outputs
- `homeModules.default` -- single module (nixos/darwin)
- `homeConfigurations.jacobfoard` -- standalone config (alias for aarch64-darwin)
- `homeConfigurations.jacobfoard-<system>` -- per-system standalone configs (e.g. `jacobfoard-aarch64-darwin`, `jacobfoard-x86_64-linux`)
- `apps.<system>.setup` -- `nix run .#setup` to switch the home config
- `devShells.<system>.default` -- shell with the home-manager CLI available

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

## Module Structure

The entry point is [jacobfoard.nix](jacobfoard.nix), which imports:

- [packages.nix](packages.nix) -- CLI tools (coreutils, ripgrep, jq, lsd, etc.)
- [programs.nix](programs.nix) -- Program configs (bat, direnv, jujutsu, wezterm, ssh)
- [git.nix](git.nix) -- Git + delta + gh + 1Password signing
- [zsh.nix](zsh.nix) -- Zsh + oh-my-zsh + powerlevel10k + fzf
- [neovim.nix](neovim.nix) -- Neovim + treesitter + LSPs + formatters
- [claude.nix](claude.nix) -- Claude Code skill files
- [xdg.nix](xdg.nix) -- XDG config files (wezterm, ghostty)

Additional directories:
- `nvim/` -- Neovim lua configuration
- `zsh/` -- Zsh config fragments (initExtra, p10k)
- `wezterm/` -- Wezterm lua config files
- `bin/` -- Shell scripts installed as packages (git-browse)
- `claude/` -- Claude Code skill definitions
