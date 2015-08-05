export ZSH=$HOME/.oh-my-zsh

#ZSH_THEME="robbyrussell"
#ZSH_THEME="blinks"
#ZSH_THEME="kphoen"
ZSH_THEME="agnoster"

plugins=(git)

source $ZSH/oh-my-zsh.sh
source ~/Dev/dotfiles/.shortcuts

# User configuration
export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

export LANG=en_US.UTF-8

