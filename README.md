# satchel
A man-bag (but can be used by anyone of course) of scripts I always want when setting up a new OSX or linux machine.

This repo contains standard config and scripts used by Countable Web Productions.

## Basic Installation

Install git
```
sudo apt-get install git
```

Clone and install satchel.
```
cd
git clone git.countable.ca:/git/satchel
./satchel/deploy/unpack-satchel.bash 
```

disable sudo password checking.
```
sudo visudo
```

Find this line:
```
%sudo ALL=(ALL) ALL
```
Change to:
```
%sudo ALL=(ALL) NOPASSWD: ALL
```

## Workstations

install desktop components
```
sudo apt-get install i3wm thunar autocutsel
cd .config/i3
rm config
ln -s ../../satchel/.i3config config
```

install oh-my-zsh
```
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

devel apps - chrome and sublime text (TODO-move this to the i3 deploy script).
```
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install google-chrome-stable
sudo apt-get update\nsudo apt-get install sublime-text-installer
sudo apt-get install xbacklight
sudo add-apt-repository ppa:nathan-renniewaldock/flux
sudo apt-get update
sudo apt-get install fluxgui
xflux -l 51 -g -123 -k 3000
```

## Servers

TODO - deploy script for a docker host on Ubuntu.


