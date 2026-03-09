# Custom Packages

This sub-flake contains custom package definitions and an overlay.

## Structure

Each package is a `.nix` file in the `pkgs/` directory:

```
pkgs/
├── flake.nix              # Exports overlay + direct package outputs
├── argocd-mcp.nix         # ArgoCD MCP server (Node.js)
├── av.nix                 # Aviator stacking tool (Go)
└── kubectl-cnpg.nix       # kubectl-cnpg plugin (Go)
```

## Usage

The overlay is exported as `overlays.default` and applied by both the `darwin` and `home-manager` sub-flakes, making all custom packages available everywhere.

Build a specific package:
```bash
nix build ./pkgs#av
```

## Updating Packages

Standard Go packages (av, kubectl-cnpg):
```bash
make update-pkgs
```


These Makefile targets use `nix-update` to bump versions/hashes and auto-commit.

## Adding a New Package

1. Create `pkgs/<name>.nix` with the package derivation
2. Add it to the overlay in `flake.nix` (`overlays.default`)
3. Add it to the `packages` output in `flake.nix`
4. Reference it from wherever needed (home-manager packages, darwin machine config, etc.)

