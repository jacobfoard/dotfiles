# Custom Packages

This sub-flake contains custom package definitions and an overlay.

## Structure

Each package should have its own directory with a `default.nix` file:

```
pkgs/
├── flake.nix          # Exports overlay
├── kubectl/
│   └── default.nix
├── k9s/
│   └── default.nix
└── ...
```

## Usage

The overlay is exported and can be referenced in the main flake using:

```nix
inputs.pkgs.url = "path:./pkgs";
```

Then apply the overlay to nixpkgs to make these packages available.

## Packages to Add (from phoenix)

- gastown
- beads 
- kubectl-cnpg
- argocd-mcp
