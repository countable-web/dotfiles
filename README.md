# dotfiles

A man-bag (but can be used by anyone of course) of scripts I always want when setting up a new computer (most things only work in Ubuntu, some work in Linux more generally, a few work in OSX). This type of repository is often called "dotfiles" by other people.

This repo contains standard config and scripts used by Countable Web Productions.

## Basic Installation

Install git
```
sudo apt-get install git
```

Clone and install dotfiles.
```
cd
git clone git.countable.ca:/git/dotfiles
./dotfiles/deploy/unpack-dotfiles.bash 
```

install oh-my-zsh (recommended)
```
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
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
./dotfiles/deploy/setup-workstation
```

### Terminator Right Click to Paste
```
sudo vi /usr/share/terminator/terminatorlib/terminal.py
```

search for on_buttonpress, and switch mouse indices

## Servers

TODO - deploy script for a docker host on Ubuntu.


