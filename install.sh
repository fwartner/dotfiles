#!/bin/sh


/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


brew update

brew tap homebrew/bundle
brew bundle --file=$HOME/.dotfiles/Brewfile

rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

rm  $HOME/.oh-my-zsh/custom/*.zsh
cp ~/.dotfiles/zsh_custom/*.zsh $HOME/.oh-my-zsh/custom/

git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

./$HOME/dotfiles/extra.sh
./$HOME/dotfiles/folders.sh
./$HOME/dotfiles/laravel.sh
./$HOME/dotfiles/mysql.sh
