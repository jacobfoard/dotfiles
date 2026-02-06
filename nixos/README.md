# NixOS configurations

This sub-flake contains NixOS system configurations for Linux machines.

**Note**: This is currently a placeholder with no active configurations. The structure is ready for when NixOS machines are added.

## Structure

- `machines/` - Individual machine configurations
  - Each machine gets its own directory with a `default.nix`
  - Machine-specific settings, hardware, and customizations
  - Include `hardware-configuration.nix` for hardware-specific settings

- `modules/` - Shared NixOS modules
  - Common configurations used across multiple machines
  - System-level settings, services, and packages

## Usage

Machines are exposed via `nixosConfigurations` output and consumed by the root flake.

Build a configuration:
```bash
nix build .#nixosConfigurations.<machine-name>.config.system.build.toplevel
```

Deploy to current system:
```bash
nixos-rebuild switch --flake .#<machine-name>
```

## Adding a Machine

1. Run `nixos-generate-config` to create initial hardware configuration
2. Create `machines/<hostname>/default.nix` with system config
3. Add to `nixosConfigurations` in `flake.nix`
4. Keep hardware-specific settings in machine directories
5. Share common configuration via modules
