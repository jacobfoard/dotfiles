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

**Important**: The `darwinConfigurations` key must match the system's actual hostname (output of `hostname`), not the machines/ directory name. For example, `"Jacobs-MacBook-Pro"` is the config key, while `macbook-pro-polarsteps` is the machines/ directory.

## Usage

Deploy to current system (from repo root):
```bash
darwin-rebuild switch --flake .
```

Or target a specific config:
```bash
darwin-rebuild switch --flake .#Jacobs-MacBook-Pro
```

Build without deploying:
```bash
nix build .#darwinConfigurations.Jacobs-MacBook-Pro.system
```

## Adding a New Machine

1. Create `machines/<hostname>/default.nix` with machine-specific config
2. Add to `darwinConfigurations` in `flake.nix`:
   ```nix
   darwinConfigurations = {
     "Jacobs-MacBook-Pro" = mkDarwinSystem {
       hostname = "macbook-pro-polarsteps";
     };
     "New-Hostname" = mkDarwinSystem {
       hostname = "new-machine-dir";
       # optional: system = "x86_64-darwin";
       # optional: username = "different-user";
     };
   };
   ```

## Determinate Nix

This flake does **NOT** include `inputs.determinate` or use the Determinate nix-darwin module.

**Why**: Determinate Nix is installed system-wide (not via Nix), and we only need standard nix-darwin config options. `nix.enable = false` because Determinate manages the daemon, but `nix.settings` and `nix.extraOptions` are still configured and picked up by Determinate's nixd.

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
