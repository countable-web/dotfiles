# dotfiles

Linux utilities for Countable Web Productions: Bootstrap servers and workstations, manage dev environment databases, and automate rote tasks.

## Basic Installation

Install curl
```
sudo apt-get install curl
cd
sh -c "$(curl -sSL https://raw.githubusercontent.com/countable-web/dotfiles/master/install.sh)"
```

To install docker.

```
./dotfiles/deploy/setup-docker
```

To set up a workstation environment.

```
./dotfiles/deploy/setup-workstation
```

### Git sync - does an add, commit, pull, push.
```
gsync
```
_warning_ : Run `git status` first, and ensure you're not adding any files you don't want. Add those to your `.gitignore` file or delete them before running `gsync`

### Fix Permissions
_warning_ : This script is recursive, so don't run it in the root directory or anywhere else ridiculous. Use it in your project folders only.

On any shared machine, Countable uses open group permissions for the "dev" group, which all users belong to. The setup script should create this group and add you to it. Once done, there's a catchall command for setting permissions so anyone in our group has full access. This is nearly always what we want, in order to be both simple and relatively secure.
```
cd <directory with permission issue>
perm
```

### Terminator Right Click to Paste
This is a suggested tweak for the terminal program. Probably only Clark cares about it.
```
sudo vi /usr/share/terminator/terminatorlib/terminal.py
```

search for on_buttonpress, and switch mouse indices

### Easily find countable.ca web addresses.
You may want to add - /etc/dhcp/dhclient.conf:append domain-name " countable.ca";

