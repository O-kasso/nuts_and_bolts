#!/usr/bin/env bash

# exit if script not executed with sudo
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# exit if any simple command fails
set -e

# trick macOS updater into thinking XCODE COMMAND LINE TOOLS are available
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

# install all pending updates
sudo softwareupdate -i -a

##### HOMEBREW #####
chown -R "$(whoami)" /usr/local
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
export HOMEBREW_NO_ANALYTICS=1
brew doctor
brew update
brew tap caskroom/cask
brew cask doctor

brew bundle --file=- <<EOF
brew 'openssl'
brew 'autoconf'
brew 'ctags'
brew 'fzf'
brew 'gdbm'
brew 'git'
brew 'heroku-toolbelt'
brew 'httpie'
brew 'jpeg'
brew 'libpng'
brew 'libtiff'
brew 'libyaml'
brew 'little-cms2'
brew 'node'
brew 'pcre'
brew 'perl'
brew 'pkg-config'
brew 'python3'
brew 'rbenv'
brew 'readline'
brew 'reattach-to-user-namespace'
brew 'ruby-build'
brew 'shellcheck'
brew 'sqlite'
brew 'the_silver_searcher'
brew 'tmux'
brew 'tree'
brew 'vim'
brew 'webp'
brew 'xz'
cask 'google-chrome'
cask 'alfred'
cask 'atom'
cask 'dashlane'
cask 'dropbox'
cask 'iterm2'
cask 'near-lock'
cask 'typora'
cask 'vlc'
cask 'webtorrent'
EOF

##### FZF EXTENSIONS #####
/usr/local/opt/fzf/install

##### BREW CLEANUP #####
brew cleanup -s
brew cask cleanup

##### RB ENV #####
find_latest_ruby() {
  rbenv install -l | grep -v - | tail -1 | sed -e 's/^ *//'
}
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
RUBY_VERSION="$(find_lastest_ruby)"
rbenv install "$RUBY_VERSION"
rbenv global "$RUBY_VERSION"

##### GEMS #####
gem update --system
gem install bropages bundler pry rails rubocop

##### NODE #####
npm install -g htmlhint csslint jshint coffeelint jsonlint

##### CONFIGS #####
cp ./{.bash_profile,.vimrc,.jshintrc} $HOME
cp ./Solarized\ Dark.itermcolors $HOME
cp ./com.googlecode.iterm2.plist $HOME
cp $(brew --prefix git)/etc/bash_completion.d/* $HOME
cp ./karabiner.json ~/.karabiner.d/configuration/
cp ./.gitignore $HOME
bundle config --global jobs $(($(sysctl -n hw.ncpu) - 1))
git config --global user.name "Omar Kassouar"
git config --global user.email "omar@kassouar.com"

##### VIM #####
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle
git clone https://github.com/w0rp/ale.git
git clone https://github.com/mattn/emmet-vim.git
git clone https://github.com/powerline/fonts.git
git clone https://github.com/junegunn/fzf.vim.git
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/mbbill/undotree.git
git clone https://github.com/vim-airline/vim-airline-themes
git clone https://github.com/vim-airline/vim-airline
git clone https://github.com/Townk/vim-autoclose.git
git clone https://github.com/tpope/vim-bundler.git
git clone https://github.com/tpope/vim-endwise.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/nathanaelkane/vim-indent-guides.git
git clone https://github.com/jelera/vim-javascript-syntax.git
git clone https://github.com/pangloss/vim-javascript.git
git clone https://github.com/gavocanov/vim-js-indent.git
git clone https://github.com/tpope/vim-rails.git
git clone https://github.com/tpope/vim-rbenv.git
git clone https://github.com/ngmy/vim-rubocop.git
git clone https://github.com/vim-ruby/vim-ruby.git
git clone https://github.com/tpope/vim-surround.git

# shellcheck source=/dev/null
source ~/.bash_profile
