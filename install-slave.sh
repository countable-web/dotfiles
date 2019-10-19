#!/bin/sh
#TODO, get this script working.
sudo easy_install pip
#sudo pip install ansible

#TODO use ansible for all this to make it idempotent.
sudo apt-get install git

git clone https://github.com/countable-web/dotfiles.git

./dotfiles/deploy/setup-core
./dotfiles/deploy/unpack
./dotfiles/deploy/setup-docker
./dotfiles/deploy/setup-jenkins

# This currently fails
sudo -u jenkins sh -c "cd /home/jenkins && $(curl -sSL https://raw.githubusercontent.com/countable-web/dotfiles/master/install.sh)"

