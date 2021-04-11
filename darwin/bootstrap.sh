#!/usr/bin/env bash

# Mostly taken from https://github.com/cachix/install-nix-action/blob/master/lib/install-nix.sh

# Configure Nix
add_config() {
  echo "$1" | sudo tee -a /tmp/nix.conf >/dev/null
}

# Set jobs to number of cores
add_config "max-jobs = auto"

# Allow binary caches for user
add_config "trusted-users = root $USER"

# Enable flakes
add_config "experimental-features = nix-command flakes"

# Nix installer flags
installer_options=(
  --daemon
  --no-channel-add
  --nix-extra-conf-file /tmp/nix.conf
)

echo "installer options: ${installer_options[@]}"

# Grab from https://github.com/numtide/nix-unstable-installer
INPUT_INSTALL_URL="https://github.com/numtide/nix-flakes-installer/releases/download/nix-2.4pre20210429_d15a196/install"

sh <(curl --retry 5 --retry-connrefused -L "${INPUT_INSTALL_URL:-https://nixos.org/nix/install}") "${installer_options[@]}"

if [[ $(uname) == "Darwin" ]]; then
  sudo mdutil -i off /nix
fi

source /etc/zshenv

nix build github:jacobfoard/dotfiles/darwin-bootstrap#darwinConfigurations.bootstrap.system

sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.bak
sudo mv /etc/zshenv /etc/zshenv.bak
sudo mv /etc/shells /etc/shells.bak

echo -e "run\tprivate/var/run" | sudo tee -a /etc/synthetic.conf >/dev/null
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t 2>/dev/null || true

mkdir -p ~/.ssh/

ssh-keyscan github.com > ~/.ssh/known_hosts

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

sudo chown -R $USER ~/.nix-defexpr 
sudo chown -R $USER /nix/var/nix/profiles/per-user/$USER 

./result/sw/bin/darwin-rebuild switch --flake github:jacobfoard/dotfiles/darwin-bootstrap#bootstrap

defaults delete com.apple.dock persistent-apps
killall Dock
