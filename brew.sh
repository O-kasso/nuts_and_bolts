#!/usr/bin/env bash
export HOMEBREW_NO_ANALYTICS=1

# fix for old permission issue, might be fixed in new homebrew versions
chown -R "$(whoami)" /usr/local

echo 'Installing Homebrew'
yes '' | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


brew doctor
brew update
brew tap caskroom/cask
brew cask doctor

echo 'Installing brew recipes'
brew bundle # casks that use .pkgs currently prompt for sudo, need to find fix

echo 'Cleaning up'
brew cleanup -s
brew cask cleanup
