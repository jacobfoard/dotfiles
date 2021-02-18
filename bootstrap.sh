#!/bin/bash

SED="sed"

case $(uname) in
Darwin)
	echo "Starting Bootstrap for macOS"
    echo
	./.bootstrap_mac.zsh
	SED="gsed"
	;;
Linux)
	echo "Starting Bootstrap for Linux"
	echo
	./.bootstrap_linux.sh
	;;
*)
	echo "Don't know how to handle uname $(uname)"
	exit 1
	;;
esac

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth 1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# # Appened theme clone to update function
UPGRADE_MSG="#Added in by bootstrap, I want check for theme upgrades too\n\necho '\\\033[32mUpdating P10K...\\\033[m'\ngit -C ~/.oh-my-zsh/custom/themes/powerlevel10k pull\n"
$SED -i "1s;^;$UPGRADE_MSG\n;" ~/.oh-my-zsh/tools/upgrade.sh

ln -s $(pwd)/ripgreprc ~/.config/.ripgreprc

mkdir -p ~/.config/jacobfoard/{zsh,tmux}

ln -s $(pwd)/.zshrc ~/.zshrc
ln -s $(pwd)/.p10k.zsh ~/.config/jacobfoard/zsh/.p10k.zsh
cat <<EOF > ~/.config/jacobfoard/zsh/work.zsh
source ~/.config/jacobfoard/zsh/aliases_work
EOF

ln -s $(pwd)/aliases ~/.config/jacobfoard/zsh/aliases
touch ~/.config/jacobfoard/zsh/aliases_work

git clone https://github.com/gpakosz/.tmux.git ~/go/src/github.com/gpakosz/.tmux
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

ln -s ~/go/src/github.com/gpakosz/.tmux/.tmux.conf ~/.tmux.conf
ln -s $(pwd)/.tmux.conf.local ~/.tmux.conf.local

mkdir -p ~/.config/nvim
ln -s $(pwd)/nvim/init.lua ~/.config/nvim/init.lua
ln -s $(pwd)/nvim/jacobfoard/ ~/.config/nvim/

echo "Successfully bootstrapped system"
