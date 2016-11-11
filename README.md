# satchel
A man-bag (but can be used by anyone of course) of scripts I always want when setting up a new computer (most things only work in Ubuntu, some work in Linux more generally, a few work in OSX).

This repo contains standard config and scripts used by Countable Web Productions.

## Basic Installation

Install git
```
sudo apt-get install git
```

install oh-my-zsh (recommended)
```
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

Clone and install satchel.
```
cd
git clone git.countable.ca:/git/satchel
./satchel/deploy/unpack-satchel.bash 
```

Satchel is installed and "deployed" now. You can make use of the following utils.

### Git sync - does an add, commit, pull, push.
```
gsync
```
_warning_ : Your default editor will pop up asking for a commit message. At this point, ensure you're not adding any files you don't want. They're listed in the message below where you're typing.

### Fix Permissions

On any shared machine, Countable uses open group permissions for the "dev" group, which all users belong to. The setup script should create this group and add you to it. Once done, there's a catchall command for setting permissions so anyone in our group has full access. This is nearly always what we want, in order to be both simple and relatively secure.
```
cd <directory with permission issue>
perm
```
_warning_ : This script is recursive, so don't run it in the root directory or anywhere else ridiculous. Use it in your project folders only.

## Disable sudo password checking
This is probably doesn't belong here but my god sudo timeouts are annoying.
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


