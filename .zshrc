
autoload -U colors && colors
PS1="%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m:%{$fg[yellow]%}%~ %{$reset_color%}%% "

function dcid {
    echo $(pwd | grep -oh "[^/]*$")
}

function gpuoff {
    echo "auto" | sudo tee /sys/bus/pci/devices/0000:01:00.0/power/control
}

function push {
    git push origin $(git branch | grep "\*" | sed "s/\* //g")
}


function pull {
    git pull origin $(git branch | grep "\*" | sed "s/\* //g")
}

function fetch {
    get fetch --all
}

function dc() {
    if command -v docker-compose >/dev/null 2>&1; then
        docker-compose $@
    else
        docker compose $@
    fi
}

function dx {
    remaining="${@:2}"
    dc exec $1 sh -c "${remaining:-bash -c \"stty cols $COLUMNS rows $LINES && bash\"}"
}

function dcp {
    id=$(dcid)
    docker cp $1 ${id}_${2}_1:/tmp/
    dx $2
}

function fullpath {
    echo "$(hostname):$(readlink -f $1)"
}

function clone {
    if git clone git@bitbucket.org:countable-web/$1.git; then
        echo "found it on github."
    else
        git clone https://countable@bitbucket.org/countable-web/$1.git
    fi
}

# Customize to your needs...
export PATH=$HOME/dotfiles/bin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:.:$HOME/.local/bin
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# for mac
#export PATH=/Developer/usr/libexec/git-core/:$PATH

source $HOME/dotfiles/.aliases



# start zgen
if [ -f ~/.zgen-setup ]; then
  source ~/.zgen-setup
fi
# end zgen

# set some history options
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify

# Share your history across all your terminal windows
setopt share_history
setopt noclobber

# set some more options
setopt pushd_ignore_dups
setopt pushd_silent

# Keep a ton of history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals

# Long running processes should return time after they complete. Specified
# in seconds.
REPORTTIME=2
TIMEFMT="%U user %S system %P cpu %*Es total"

# alias expansion http://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html
globalias() {
   if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
     zle _expand_alias
     zle expand-word
   fi
   zle self-insert
}

zle -N globalias

bindkey " " globalias
bindkey "^ " magic-space           # control-space to bypass completion
bindkey -M isearch " " magic-space # normal space during searches

# shift + left/right arrow key to move cursor by a word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# for mac
#export GIT_EXEC_PATH=/opt/local/libexec/git-core

# zgen zsh plugins
source "${HOME}/.zgen/zgen.zsh"
#zgen load zsh-users/zsh-syntax-highlighting
zgen load zsh-users/zsh-history-substring-search

# Set keystrokes for substring searching
#zmodload zsh/terminfo
#bindkey "$terminfo[kcuu1]" history-substring-search-up
#bindkey "$terminfo[kcud1]" history-substring-search-down

#zgen load djui/alias-tips
zgen load zsh-users/zsh-autosuggestions
#zgen load chrissicool/zsh-256color

export LSCOLORS='Exfxcxdxbxegedabagacad'
export LS_COLORS='di=1;34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'


#zgen load skx/sysadmin-util

#if [ -f  $HOME/.nvm/nvm.sh ]; then
#   source $HOME/.nvm/nvm.sh
#   nvm use stable
#fi


# This is disabled for now as it causes permission errors.
#source $HOME/dotfiles/bin/z.sh

export AWS_DEFAULT_PROFILE=default

