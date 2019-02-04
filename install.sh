#!/bin/sh

sudo apt-get install git

git clone https://github.com/countable-web/dotfiles.git

./dotfiles/deploy/setup-core
./dotfiles/deploy/unpack

