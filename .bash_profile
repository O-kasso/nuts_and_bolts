####################
#       PATH       #
####################

# make rbenv actually work
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# make golang work
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin


####################
#       MISC       #
####################

# default editor
export EDITOR=vim


# FZF keybindings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# don't send analytics to homebrew
export HOMEBREW_NO_ANALYTICS=1

# make Shopify devtools work
if [[ -f /opt/dev/dev.sh ]]; then source /opt/dev/dev.sh; fi

####################
#    APPEARANCE    #
####################

# pretty prompt
ORANGE=$(tput setaf 9)
VIOLET=$(tput setaf 13)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)
export PS1='\[$VIOLET\]{\@}\[$CYAN\]{\w\[$ORANGE\]$(__git_ps1)\[$CYAN\]} $ \[$RESET\]'
export PS2="${COLOR}\[\@\] > ${RESET}"

# cool prompt currently not working correctly
# export PS1='\[$VIOLET\]{💻  \h} \[$CYAN\]{🕒  \@} {📂  \w\[$ORANGE\]$(__git_ps1)\[$CYAN\]} $ \[$RESET\]'

# export GIT_PS1_SHOWDIRTYSTATE=1
source ~/git-completion.bash # completion
source ~/git-prompt.sh # prompt

# tab completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

####################
#      ALIASES     #
####################

## navigating
alias ls='ls -Gh'
alias ll='ls -Glha'
alias dropb='cd ~/Dropbox'
alias tree='tree -C -L 3'
alias bashp='vim ~/.bash_profile'
alias code='cd ~/Code'
alias sob='source ~/.bash_profile'

## vim
alias vimsp='vim $1 +sp $2 +n'
alias vimvsp='vim $1 +vsp $2 +n'
alias vimrc='vim ~/.vimrc'

## git
alias gst='git status'
alias gcm='git checkout master'
alias gpull='git pull && ctags -R --languages=ruby,javascript --exclude=.git --exclude=log .'
alias gcmp='gcm && gpull'
alias grb='git_rebase_latest_master'
alias gup='git_upstream_push_and_launch_pr_in_browser'
alias gconf='git diff --name-only --diff-filter=U' # view all merge conflicts
alias glog='git_pretty_log $1'
alias gdiff='git_diff_since'

alias goops='git checkout -- $1'
alias gdang='git_dangling_commits_tree' # view lost commits and stashes
alias gdamn='git commit --amend --no-edit'
alias gshit='git_interactive_rebase_x_commits_ago $1'
alias gfuck='git_commit_amend_all_and_force_push'

## shopify
#alias oo='dev cd shopify'
#alias ii='dev cd shipify'
#alias ddu='dev down && dev up'
#alias ddd='dev down && dev up && dev server'
#alias killpuma='pgrep -f puma | xargs kill -9'

###################
#    FUNCTIONS    #
###################

# rename current terminal tab
function title { echo -ne "\033]0;"$*"\007"; }

# display a tree of all dangling commits
function git_dangling_commits_tree {
  git log --graph --oneline --decorate $( git fsck --no-reflog | awk '/dangling commit/ {print $3}' );
}

# force push all changes on top of previous commit
function git_commit_amend_all_and_force_push {
  if [ "$(git symbolic-ref --short HEAD)" != "master" ] ; then git commit -a --amend --no-edit && git push -f; fi;
}

# update to latest master and rebase current branch on top of it
function git_rebase_latest_master {
  gstatus=$(git status --porcelain) && \
    if [ "$gstatus" != "" ] ; then git stash --include-untracked ; fi && \
    git fetch origin master:master && \
    git rebase master && \
    if [ "$gstatus" != "" ] ; then git stash pop ; fi;
}

# push to new upstream branch with same name as local branch, then open default browser to Github page for new branch
function git_upstream_push_and_launch_pr_in_browser {
  cd $(git rev-parse --show-toplevel) && \
  git push --set-upstream origin $(git symbolic-ref --short HEAD) && \
  open "https://github.com/Shopify/$(basename "$PWD")";
}

function git_interactive_rebase_x_commits_ago {
  if [[ $1 =~ ^[0-9]+$ ]] ; then git rebase -i HEAD~$1 ; fi;
}

function git_pretty_log {
  if [[ $1 =~ ^[0-9]+$ ]] ; then
    git log -$1 --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit
  else
    git log -20 --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit
  fi
}

function git_diff_since {
  if [[ $1 =~ ^[0-9]+$ ]] ; then
    git diff -w HEAD~$1
  else
    git diff -w
  fi
}
