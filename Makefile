.PHONY: update-all-flakes update-ccstatusline update-pkgs

update-all-flakes:
	nix flake update --flake .
	nix flake update --flake ./pkgs
	nix flake update --flake ./home-manager
	nix flake update --flake ./darwin
	nix flake update --flake ./nixos

# Update all standard packages (excludes ccstatusline/argocd-mcp which need extra steps)
update-pkgs:
	cd pkgs && nix-update --commit --flake av
	cd pkgs && nix-update --commit --flake beads
	cd pkgs && nix-update --commit --flake kubectl-cnpg

# Update ccstatusline: bump version/hash with nix-update, then regenerate bun.nix
# Usage: make update-ccstatusline [VERSION=2.0.26]
VERSION ?= $(shell gh api repos/sirmalloc/ccstatusline/tags --jq '.[0].name' | sed 's/^v//')
update-ccstatusline:
	@echo "Updating ccstatusline to $(VERSION)..."
	cd pkgs && nix-update --version=$(VERSION) --flake ccstatusline
	$(eval _TMPDIR := $(shell mktemp -d))
	git clone --depth 1 --branch v$(VERSION) https://github.com/sirmalloc/ccstatusline.git $(_TMPDIR)/ccstatusline
	nix run github:nix-community/bun2nix -- -o pkgs/ccstatusline-bun.nix --lockfile $(_TMPDIR)/ccstatusline/bun.lock
	rm -rf $(_TMPDIR)
	nix build ./pkgs\#ccstatusline
	@echo "ccstatusline updated to $(VERSION) and build verified"
