# dotfiles

This repo contains standard config and scripts used by Countable Web Productions. It includes scripts and settings to automate repetitive tasks in our workflow.

## Basic Installation

From your home dir:
```
sh -c "$(curl -sSL https://raw.githubusercontent.com/countable-web/dotfiles/master/install.sh)"
```

then

```
./dotfiles/deploy/setup-core
```

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

## Docker

```
./dotfiles/deploy/setup-docker
```

### Easily find countable.ca web addresses.
You may want to add - /etc/dhcp/dhclient.conf:append domain-name " countable.ca";

