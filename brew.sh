#!/usr/bin/env bash
export HOMEBREW_NO_ANALYTICS=1

# fix for old permission issue, might be fixed in new homebrew versions
chown -R "$(whoami)" /usr/local

yes '' | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


brew doctor
brew update
brew tap caskroom/cask
brew cask doctor

# casks that use .pkgs currently prompt for sudo, need to find fix
brew bundle

brew cleanup -s
brew cask cleanup
