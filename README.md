# dotfiles

Personal Nix dotfiles for macOS (nix-darwin) and Linux (NixOS), managed with home-manager.

## Architecture

This repo uses a **modular sub-flake composition** pattern. The root `flake.nix` composes four independent sub-flakes, each with its own `flake.nix`:

| Directory | Purpose |
|-----------|---------|
| [`pkgs/`](pkgs/) | Custom package definitions + overlay |
| [`home-manager/`](home-manager/) | home-manager user environment (shell, editor, tools) |
| [`darwin/`](darwin/) | nix-darwin system configurations (macOS) |
| [`nixos/`](nixos/) | NixOS system configurations (Linux, placeholder) |
| [`template/`](template/) | Flake template for new projects |

All sub-flakes share a single `nixpkgs` pin via `follows`. The `pkgs` overlay is applied everywhere so custom packages are available in all contexts.

## Quick Start

**Prerequisites**: [Determinate Nix](https://determinate.systems/nix-installer/) installed.

**Apply macOS system + user config:**
```bash
darwin-rebuild switch --flake .
```

**Apply home-manager standalone:**
```bash
home-manager switch --flake ./home-manager#jacobfoard
```

**Enter dev shell:**
```bash
nix develop
```

## Maintenance

```bash
make update-all-flakes                     # update all flake inputs
make update-pkgs                           # bump custom Go packages
make update-ccstatusline [VERSION=x.y.z]   # bump ccstatusline (bun2nix)
```

## Key Details

- **Formatter**: `nixfmt` (RFC-style)
- **Nix daemon**: Managed by Determinate Nix (`nix.enable = false`)
- **SSH/Git signing**: 1Password agent
- **GUI apps**: Homebrew casks via nix-darwin (auto-cleaned on rebuild)
- **Shell**: Zsh + powerlevel10k + oh-my-zsh
- **Editor**: Neovim with lazy.nvim + treesitter + LSPs

See [CLAUDE.md](CLAUDE.md) for detailed architecture notes and conventions.
