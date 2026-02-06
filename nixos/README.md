# NixOS configurations

This sub-flake contains all NixOS system configurations for Linux machines.

## Structure

- `machines/` - Individual machine configurations
  - Each machine gets its own directory with a `default.nix`
  - Machine-specific settings, hardware, and customizations
  - Include `hardware-configuration.nix` for hardware-specific settings

- `modules/` - Shared NixOS modules
  - Common configurations used across multiple machines
  - System-level settings, services, and packages

## Usage

Machines are exposed via `nixosConfigurations` output and consumed by the main v7 flake.

Build a configuration:
```bash
nix build .#nixosConfigurations.<machine-name>.config.system.build.toplevel
```

Deploy to current system:
```bash
nixos-rebuild switch --flake .#<machine-name>
```

## Tips

- Use `nixos-generate-config` to create initial hardware configuration
- Keep hardware-specific settings in machine directories
- Share common system configuration via modules
