#!/bin/zsh

# https://stackoverflow.com/questions/9901210/bash-source0-equivalent-in-zsh
REPO_PATH=$(dirname ${(%):-%x})
source $REPO_PATH/.shared.sh

function printWithSpacing() {
  echo
  for msg in $@; do 
    echo $msg
  done
  echo
}

xcode-select --install

echo "Accept the prompt from xcode-tools"
read '?Press enter once the install has finished ' unused

F_NAME="Jacob"
L_NAME="Foard"

echo
read '?Email: ' EMAIL

read '?Generate SSH Key? [Y/n]' SSH

SSH=${SSH:-y}
SSH=$(echo $SSH | tr '[:upper:]' '[:lower:]' | head -c 1)

if [[ $SSH == "y" ]]; then
    printWithSpacing "Generating SSH key"
    generateSSH $EMAIL

    /bin/cat $HOME/.ssh/id_rsa.pub | pbcopy

    printWithSpacing "Copying SSH key to clipboard" \
        "Opening https://github.com/settings/ssh/new"

    open "https://github.com/settings/ssh/new"
    read "?Then paste and hit enter: " unused
fi


printWithSpacing "Adding in defaults for git"
gitDefaults $EMAIL $F_NAME $L_NAME


read '?Install homebrew? [Y/n]' HOMEBREW

HOMEBREW=${HOMEBREW:-y}
HOMEBREW=$(echo $HOMEBREW | tr '[:upper:]' '[:lower:]' | head -c 1)

if [[ $HOMEBREW == "y" ]]; then
printWithSpacing "Installing homebrew"
read "?Press enter to continue " unused

    curl -fsSL https://raw.githubusercontent.com/homebrew/install/master/install.sh | bash
fi

printWithSpacing "Downloading some pre-reqs"
brew install fzf gnupg coreutils


read '?Generate PGP key? [Y/n]' PGP

PGP=${PGP:-y}
PGP=$(echo $PGP | tr '[:upper:]' '[:lower:]' | head -c 1)

if [[ $PGP == "y" ]]; then
    printWithSpacing "Generating PGP Key"
    generatePGP $EMAIL

    printWithSpacing "Copying Public Key to clipboard" \
        "Opening https://github.com/settings/gpg/new" 
    open "https://github.com/settings/gpg/new"

    read "?Then paste, save and hit enter: " unused
fi

printWithSpacing "Select tools to install"
cat $REPO_PATH/brew/tools | fzf -m --header-lines 6 --phony --no-info --reverse --bind 'enter:toggle,space:accept' | sort | uniq |  tr '\n' ' ' | xargs brew install 
cat $REPO_PATH/brew/casks | fzf -m --header-lines 6 --phony --no-info --reverse --bind 'enter:toggle,space:accept' | sort | uniq |  tr '\n' ' ' | xargs brew install --casks

$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

printWithSpacing "Setting Default macOS Preferences"

export SR_NUM=$(ioreg -l | grep IOPlatformSerialNumber | awk '{print $4}' | tr -d \")
sudo scutil --set ComputerName "$SR_NUM"
sudo scutil --set HostName "$SR_NUM"
sudo scutil --set LocalHostName "$SR_NUM"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$SR_NUM"


# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Wipe all (default) app icons from the Dock
defaults delete com.apple.dock persistent-apps

# Dock
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock largesize -int 100
defaults write com.apple.dock tilesize -int 50

defaults write -g ApplePressAndHoldEnabled -bool false

# Itsycal
defaults write com.mowglii.ItsycalApp ClockFormat -string "E MMM dd h:mm a"
defaults write com.mowglii.ItsycalApp HideIcon -int 1
defaults write com.mowglii.ItsycalApp ShowEventDays -int 7
defaults write com.mowglii.ItsycalApp SizePreference -int 1
defaults write com.mowglii.ItsycalApp UseOutlineIcon -int 0

killall Dock

git clone https://github.com/epk/SF-Mono-Nerd-Font ~/go/src/github.com/epk/SF-Mono-Nerd-Font
cp ~/go/src/github.com/epk/SF-Mono-Nerd-Font/*.otf ~/Library/Fonts/
