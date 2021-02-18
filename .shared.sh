#!/bin/bash

function generateSSH() {
	ssh-keygen -t rsa -b 4096 -C "$1"
	ssh-add -K $HOME/.ssh/id_rsa
}

function gitDefaults() {
	cat <<EOF > $HOME/.gitconfig
[url "git@github.com:"]
  insteadOf = https://github.com/
[user]
  email = $1
  name = $2 $3
[core]
  excludesfile = $HOME/.gitignore
[pull]
  rebase = true
[rebase]
  autoStash = true
[init]
  defaultBranch = main
EOF

  cat <<EOF > $HOME/.gitignore
.DS_Store
.vscode
tmp
vendor
EOF
}

function generatePGP() {
	cat << EOF > pgp-gen
Key-Type: RSA
Key-Length: 4096
Name-Real: Jacob Foard
Name-Comment: "$(hostname)-$(data "+%Y%b%d")"
Name-Email: $1
Expire-Date: 0
EOF

	pgp --batch --gen-key pgp-gen
	rm pgp-gen
}
