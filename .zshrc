
#autoload -U colors && colors
#PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "


function push {
    git push origin $(git branch | grep "\*" | sed "s/\* //g")
}


function pull {
    git pull origin $(git branch | grep "\*" | sed "s/\* //g")
}

# Customize to your needs...
export PATH=$HOME/dotfiles/bin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:.:$HOME/.local/bin

#fpath=($fpath $HOME/dotfiles/.zsh/functions)
#typeset -U fpath
#setopt promptsubst
#autoload -U promptinit
#promptinit
#prompt wunjo

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# for mac
#export PATH=/Developer/usr/libexec/git-core/:$PATH

source $HOME/dotfiles/.aliases

# for mac
#export GIT_EXEC_PATH=/opt/local/libexec/git-core

