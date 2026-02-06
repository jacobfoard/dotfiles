# CLAUDE.md -- dotfiles

Personal Nix dotfiles for macOS (nix-darwin) and Linux (NixOS) machines, managed with home-manager.

## Repo Structure

The repo uses a **modular sub-flake architecture**. The root `flake.nix` composes four independent sub-flakes, each with its own `flake.nix` and lock file:

```
.
├── flake.nix              # Root flake -- composes sub-flakes, re-exports their outputs
├── Makefile               # Update helpers (flake deps, custom packages)
├── darwin/                # nix-darwin system configurations (macOS)
│   ├── flake.nix          # Sub-flake: darwinConfigurations
│   ├── modules/           # Shared darwin modules (common.nix)
│   └── machines/          # Per-host configs (hostname dirs with default.nix)
├── home-manager/          # home-manager user environment
│   ├── flake.nix          # Sub-flake: homeModules, homeConfigurations
│   ├── jacobfoard.nix     # Entry point -- imports all modules below
│   ├── packages.nix       # CLI tools (coreutils, ripgrep, jq, etc.)
│   ├── programs.nix       # Program configs (bat, direnv, jujutsu, wezterm, ssh)
│   ├── git.nix            # Git + delta + gh
│   ├── zsh.nix            # Zsh + oh-my-zsh + powerlevel10k + fzf
│   ├── neovim.nix         # Neovim + treesitter + LSPs + formatters
│   ├── claude.nix         # Claude Code skill files (~/.claude/skills/)
│   ├── xdg.nix            # XDG config files (wezterm, ghostty)
│   ├── nvim/              # Neovim lua configuration (symlinked via xdg)
│   ├── zsh/               # Zsh config fragments (initExtra, p10k)
│   ├── wezterm/           # Wezterm lua config files
│   └── bin/               # Shell scripts installed as packages (git-browse)
├── nixos/                 # NixOS system configurations (Linux) -- currently empty
│   └── flake.nix          # Sub-flake: nixosConfigurations
├── pkgs/                  # Custom package definitions + overlay
│   ├── flake.nix          # Sub-flake: overlays.default, packages.<system>.*
│   ├── av.nix             # av (Aviator stacking tool)
│   ├── beads.nix          # beads
│   ├── ccstatusline.nix   # ccstatusline (Bun-based, uses bun2nix)
│   ├── argocd-mcp.nix     # argocd-mcp
│   ├── kubectl-cnpg.nix   # kubectl-cnpg plugin
│   └── gastown.nix        # gastown (currently disabled -- sandbox build issue)
└── template/              # Flake template for new projects (nix flake new -t)
```

## Architecture -- Sub-Flake Composition

Each subdirectory (`pkgs/`, `darwin/`, `home-manager/`, `nixos/`) is a standalone flake referenced by the root via `path:./` inputs. The root flake wires them together using `follows` to ensure a single nixpkgs:

```
root flake.nix
  ├── pkgs       (path:./pkgs)        -- overlay with custom packages
  ├── home       (path:./home-manager) -- home-manager modules
  ├── darwin     (path:./darwin)       -- nix-darwin configs (consumes pkgs + home)
  └── nixos      (path:./nixos)        -- NixOS configs (placeholder)
```

All sub-flake inputs follow the root's `nixpkgs`, `home-manager`, and `nix-darwin` pins to keep one consistent set of dependencies.

The `pkgs` sub-flake exports an overlay (`overlays.default`) that adds custom packages. This overlay is applied by both `darwin` and `home-manager` sub-flakes so custom packages are available everywhere.

## How to Build and Apply

**Apply darwin configuration to current macOS machine:**
```bash
darwin-rebuild switch --flake .
```
The flake key must match `hostname` (`Jacobs-MacBook-Pro`). The command applies both system-level (nix-darwin) and user-level (home-manager) configuration in one step.

**Apply home-manager standalone (no system rebuild):**
```bash
home-manager switch --flake ./home-manager#jacobfoard
# or
nix run ./home-manager#setup
```

**Update all flake inputs:**
```bash
make update-all-flakes
```

**Update custom packages (version bump + commit):**
```bash
make update-pkgs                           # standard Go packages
make update-ccstatusline [VERSION=x.y.z]   # bun-based package (extra steps)
```

**Build a specific custom package:**
```bash
nix build ./pkgs#av
nix build ./pkgs#beads
```

**Enter dev shell with custom packages:**
```bash
nix develop
```

## Key Conventions

- **Nix formatter**: `nixfmt` (RFC-style) is used. Run `nixfmt` on `.nix` files before committing.
- **Determinate Nix**: The system uses Determinate Nix (installed outside Nix). `nix.enable = false` in darwin config because Determinate manages the daemon. The `nix.settings`, `nix.extraOptions`, etc. are still configured and picked up by Determinate's nixd. Do not add `inputs.determinate` to the flakes.
- **1Password SSH agent**: Git signing and SSH keys use 1Password's agent socket. The signing key is configured in `home-manager/git.nix`.
- **Homebrew casks**: GUI apps are managed via Homebrew in `darwin/machines/<hostname>/default.nix`, with `onActivation.cleanup = "zap"` -- unlisted casks will be removed on rebuild.
- **Custom packages as overlay**: All custom packages go in `pkgs/` as individual `.nix` files and are wired into `pkgs/flake.nix` as both overlay entries and direct package outputs.
- **Machine configs**: Darwin machine configs live at `darwin/machines/<hostname>/default.nix`. The hostname directory name is used in `mkDarwinSystem`. The `darwinConfigurations` key must match the actual system hostname (e.g. `"Jacobs-MacBook-Pro"`), which may differ from the machines/ directory name.
- **Home module composition**: `jacobfoard.nix` is the single entry point that imports all other home-manager modules. Add new home-manager features as separate `.nix` files and import them there.
- **Binary caches**: Cachix (`jacobfoard-dotfiles.cachix.org`) and `nix-community.cachix.org` are configured as substituters.

## Adding Things

**New home-manager program/tool:**
1. Create `home-manager/<name>.nix` with the configuration
2. Add it to the imports list in `home-manager/jacobfoard.nix`

**New custom package:**
1. Create `pkgs/<name>.nix` with the package derivation
2. Add it to the overlay in `pkgs/flake.nix` (`overlays.default`)
3. Add it to the `packages` output in `pkgs/flake.nix`
4. Reference it from wherever needed (darwin machine config, home-manager packages, etc.)

**New darwin machine:**
1. Create `darwin/machines/<hostname>/default.nix`
2. Add entry in `darwin/flake.nix` `darwinConfigurations` using `mkDarwinSystem { hostname = "<hostname>"; }`
3. The key in `darwinConfigurations` must match the system's actual hostname

## Nix Version and Features

- Uses Nix 2.26+ features (`path:./` sub-flake references)
- Experimental features enabled: `nix-command`, `flakes`, `external-builders`
- nixpkgs channel: `nixpkgs-unstable`
- Uses `direnv` + `nix-direnv` for automatic dev shell activation (`.envrc` at root)
