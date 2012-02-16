#!/bin/sh

mkdir -p $HOME/.bak

mv $HOME/.bashrc $HOME/.bak
cp $HOME/satchel/.bashrc $HOME/

mv $HOME/.zshrc $HOME/.bak
cp $HOME/satchel/.zshrc $HOME/

mv $HOME/.vimrc $HOME/.bak
cp $HOME/satchel/.vimrc $HOME/

mv $HOME/.gitconfig $HOME/.bak
cp $HOME/satchel/.gitconfig $HOME/

