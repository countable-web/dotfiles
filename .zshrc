autoload -U colors && colors
PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# Customize to your needs...
export PATH=$HOME/satchel/bin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin
source $HOME/.nvm/nvm.sh
nvm use v0.4.11

fpath=($fpath $HOME/satchel/.zsh/functions)
typeset -U fpath
setopt promptsubst
autoload -U promptinit
promptinit
prompt wunjo

