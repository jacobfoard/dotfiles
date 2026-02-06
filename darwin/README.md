# nix-darwin configurations

This sub-flake contains all nix-darwin system configurations for macOS machines.

## Structure

- `machines/` - Individual machine configurations
  - Each machine gets its own directory with a `default.nix`
  - Machine-specific settings, hardware, and customizations

- `modules/` - Shared nix-darwin modules
  - `common.nix` - Base configuration for all darwin machines (nix settings, zsh, keyboard, TouchID)

## Inputs

This flake consumes:
- `nixpkgs` - Nix packages (follows parent)
- `darwin` - nix-darwin modules
- `home-manager` - Home Manager modules (for user configuration)
- `home` (path:../home-manager) - Our home-manager sub-flake
- `pkgs` (path:../pkgs) - Our custom packages overlay

## Home-Manager Integration

Darwin machines automatically integrate with home-manager via the `mkDarwinSystem` helper:

```nix
mkDarwinSystem {
  hostname = "macbook-pro-polarsteps";
  # username defaults to "jacobfoard"
  # system defaults to "aarch64-darwin"
};
```

This:
1. Applies the custom packages overlay from `pkgs`
2. Loads common darwin configuration from `modules/common.nix`
3. Loads machine-specific configuration from `machines/<hostname>/default.nix`
4. Sets up home-manager with:
   - `useGlobalPkgs = true` - Use system nixpkgs
   - `useUserPackages = true` - Install packages to user profile
   - Loads the user module from `home.homeModules.default`

## Usage

Build a configuration:
```bash
nix build .#darwinConfigurations.macbook-pro-polarsteps.system
```

Deploy to current system:
```bash
darwin-rebuild switch --flake .#macbook-pro-polarsteps
```

Or from the parent v7 flake:
```bash
darwin-rebuild switch --flake /path/to/v7#macbook-pro-polarsteps
```

## Adding a New Machine

1. Create `machines/<hostname>/default.nix` with machine-specific config
2. Add to `darwinConfigurations` in `flake.nix`:
   ```nix
   darwinConfigurations = {
     "macbook-pro-polarsteps" = mkDarwinSystem {
       hostname = "macbook-pro-polarsteps";
     };
     "new-machine" = mkDarwinSystem {
       hostname = "new-machine";
       # optional: system = "x86_64-darwin";
       # optional: username = "different-user";
     };
   };
   ```

## Determinate Nix

This flake does **NOT** include `inputs.determinate` or use the Determinate nix-darwin module.

**Why**: Determinate Nix is installed system-wide (not via Nix), and we only need standard nix-darwin config options. The Determinate flake module is only needed for advanced features like:
- `buildMachines` (complex remote builder configs)
- `determinateNixd` (memory/CPU tuning)
- Custom Linux builder VMs

**Configuration**: Use standard nix-darwin options in machine configs:
```nix
{
  nix.settings.trusted-users = [ "root" "username" ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    external-builders = [/* ... */]
  '';
}
```

See [v7/NOTES.md](../NOTES.md) for full details.

