#!/bin/bash

echo "source $HOME/satchel/.bashrc" >> .bashrc
ln -s satchel/.vimrc
ln -s satchel/.vim
ln -s satchel/.gitconfig
ln -s satchel/.gitignore

