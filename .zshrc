autoload -U colors && colors
PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# Customize to your needs...
export PATH=$HOME/satchel/bin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin

alias ll="ls -l"
alias djs="python manage.py runserver 0.0.0.0:8080"
alias stf="ssh -i keys/STF-keypair.pem ubuntu@ec2-50-112-228-89.us-west-2.compute.amazonaws.com"
alias pias-pizza="ssh -i keys/OAS-Pizza-keypair.pem ubuntu@ec2-50-112-76-219.us-west-2.compute.amazonaws.com"
fpath=($fpath $HOME/satchel/.zsh/functions)
typeset -U fpath
setopt promptsubst
autoload -U promptinit
promptinit
prompt wunjo

export PATH=/opt/local/bin:/opt/local/sbin:/Developer/usr/libexec/git-core/:$PATH
if [ `sysctl -n hw.cpu64bit_capable` -eq 1 ] ; then echo "+universal" | sudo tee -a /opt/local/etc/macports/variants.conf; else echo "not 64bit capable"; fi

source $HOME/satchel/.aliases
export GIT_EXEC_PATH=/opt/local/libexec/git-core
. $HOME/.nvm/nvm.sh
nvm use v0.10.5
