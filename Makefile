.PHONY: update-all-flakes update-pkgs

update-all-flakes:
	nix flake update --flake .
	nix flake update --flake ./pkgs
	nix flake update --flake ./home-manager
	nix flake update --flake ./darwin
	nix flake update --flake ./nixos

# Update all standard packages (excludes argocd-mcp which needs extra steps)
update-pkgs:
	cd pkgs && nix-update --commit --flake av
	cd pkgs && nix-update --commit --flake beads
	cd pkgs && nix-update --commit --flake kubectl-cnpg
