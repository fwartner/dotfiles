#!/bin/sh
echo "Setting up your Mac..."

git clone https://github.com/fwartner/new-mac.git $HOME/.dotfiles

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s .zshrc $HOME/.zshrc

# Removes .gitconfig from $HOME (if it exists) and symlinks the .gitconfig file from the .dotfiles
rm -rf $HOME/.gitconfig
ln -s .gitconfig $HOME/.gitconfig

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

echo "source $(brew --prefix)/opt/spaceship/spaceship.zsh" >>! ~/.zshrc

# Create folders
mkdir $HOME/Development
mkdir $HOME/Development/Projects
mkdir $HOME/Development/Code
mkdir $HOME/Development/Homelab
mkdir $HOME/Development/Smarthome
mkdir $HOME/Development/cloud37
mkdir $HOME/Development/Websites

# SSH
echo "Setting up SSH..."
echo "Generating a new SSH key for GitHub..."

# Generating a new SSH key
# https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
ssh-keygen -t ed25519 -C $1 -f ~/.ssh/id_ed25519

# Adding your SSH key to the ssh-agent
# https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
eval "$(ssh-agent -s)"

touch ~/.ssh/config
echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_ed25519" | tee ~/.ssh/config

ssh-add -K ~/.ssh/id_ed25519

# Adding your SSH key to your GitHub account
# https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
echo "run 'pbcopy < ~/.ssh/id_ed25519.pub' and paste that into GitHub"

echo "Setting up Spaceship..."
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1

# AppStore Apps
echo "Setting up Apps from the Appstore..."
mas install 946399090 # Telegram Lite
mas install 441258766 # Magnet
mas install 497799835 # Xcode
mas install 1109319285 # SSH Config Editor
mas install 310633997 # WhatsApp
mas install 425424353 # The Unarchiver
mas install 1099568401 # Home Assistant
mas install 1451685025 # WireGuard
mas install 1455214828 # MQTT Explorer
mas install 937984704 # Amphetamine
mas install 1289583905 # Pixelmator Pro
mas install 1352778147 # Bitwarden

echo "Setting up Git Repositories..."
git clone https://github.com/fwartner/homeassistant-config.git $HOME/Development/Smarthome/ha-config
git clone https://github.com/fwartner/home-assistant-wakewords-collection $HOME/Development/Smarthome/ha-wakewords-collection
git clone https://github.com/fwartner/homeassistant-addons.git $HOME/Development/Smarthome/ha-addons
git clone https://github.com/fwartner/ps5-mqtt.git $HOME/Development/Smarthome/ha-ps5-mqtt
git clone https://github.com/fwartner/littlelink.git $HOME/Development/Websites/fwartner-link
git clone

echo "Setting up Kubernetes Toolchain..."
curl -sLS https://get.k3sup.dev | sh

echo "Setting up Devbox..."
curl -fsSL https://get.jetpack.io/devbox | bash
