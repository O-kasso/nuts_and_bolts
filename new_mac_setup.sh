#!/usr/bin/env bash

# exit if script not executed with sudo
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# exit if any simple command fails
set -e

# make sure scripts are being run in project directory
cd "$(dirname "$0")"

# trick macOS updater into thinking XCODE COMMAND LINE TOOLS are available
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

# install XCODE COMMAND LINE TOOLS and other pending updates
softwareupdate -i -a

##### HOMEBREW #####
sudo -u "$(who -m | awk '{ print $1 }')" ./brew.sh # brew doesn't work with root privileges

##### FZF EXTENSIONS #####
yes | /usr/local/opt/fzf/install &

##### RUBY #####
find_latest_ruby() {
  rbenv install -l | grep -v - | tail -1 | sed -e 's/^ *//'
}
# export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
RUBY_VERSION="$(find_latest_ruby)"
rbenv install "$RUBY_VERSION"
rbenv global "$RUBY_VERSION"

##### GEMS #####
gem update --system
gem install bundler
bundle config --global jobs $(($(sysctl -n hw.ncpu) - 1)) # parallelize bundler
bundle install --system

##### PYTHON #####
find_latest_python() {
  pyenv install -l | grep -v "[-a-z]" | tail -1 | sed -e 's/^ *//'
}
eval "$(pyenv init -)"
PYTHON_VERSION="$(find_latest_python)"
pyenv install "$PYTHON_VERSION"
pyenv global "$PYTHON_VERSION"

##### NODE #####
npm install -g htmlhint csslint jshint coffeelint jsonlint

##### CONFIGS #####
cp "$(brew --prefix git)/etc/bash_completion.d"/* "$HOME"
cp ./iterm2/{Solarized\ Dark.itermcolors,com.googlecode.iterm2.plist} "$HOME"
cp ./dotfiles/{.bash_profile,.vimrc,.gitconfig,.gitignore,.rubocop.yml,.jshintrc} "$HOME"
cp -r ./dotfiles/karabiner.json ~/.config/karabiner/

##### VIM #####
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle
git clone https://github.com/w0rp/ale.git
git clone https://github.com/Raimondi/delimitMate.git
git clone https://github.com/mattn/emmet-vim.git
git clone https://github.com/powerline/fonts.git
git clone https://github.com/junegunn/fzf.vim.git
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/mbbill/undotree.git
git clone https://github.com/vim-airline/vim-airline-themes
git clone https://github.com/vim-airline/vim-airline
git clone https://github.com/tpope/vim-bundler.git
git clone https://github.com/tpope/vim-endwise.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/airblade/vim-gitgutter.git
git clone https://github.com/nathanaelkane/vim-indent-guides.git
git clone https://github.com/jelera/vim-javascript-syntax.git
git clone https://github.com/pangloss/vim-javascript.git
git clone https://github.com/gavocanov/vim-js-indent.git
git clone https://github.com/tpope/vim-rails.git
git clone https://github.com/tpope/vim-rbenv.git
git clone https://github.com/ngmy/vim-rubocop.git
git clone https://github.com/vim-ruby/vim-ruby.git
git clone https://github.com/tpope/vim-surround.git

# install Powerline fonts
fonts/install.sh

# install iTerm2 shell integration
cd && curl -L https://iterm2.com/misc/install_shell_integration_and_utilities.sh | bash

# shellcheck source=/dev/null
source ~/.bash_profile
