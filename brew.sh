#!/usr/bin/env bash
export HOMEBREW_NO_ANALYTICS=1

brew doctor
brew update
brew tap caskroom/cask
brew cask doctor

brew bundle

brew cleanup -s
brew cask cleanup
