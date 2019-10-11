# dotfiles

Linux utilities for Countable Web Productions: Bootstrap servers and workstations, manage dev environment databases, and automate rote tasks.

## Basic Installation (Generic Linux Workstation)

Install curl, then run the automated installer.
```
sudo apt-get install curl
cd
sh -c "$(curl -sSL https://raw.githubusercontent.com/countable-web/dotfiles/master/install.sh)"
```

This will do the following to your machine:
  * Change your default shell to zsh.
  * Install the zgen package manager for zsh, which lets you add shell utilities.
  * Sets up much better autocompletion than the default.
  * Create a local ssh key for you machine.
  * Prevent `sudo` asking your password.
  * Allow GIT to store your credentials in memory temporarily, to avoid needing to enter passwords multiple times per session.
  * Installs several convenient scripts, see below.

## Jenkins Slave Node Installation
To do set up a server as a jenkins slave on a remote node, do this instead where `node-direct.countable.ca` is the new node's DNS.
```
ssh node-direct.countable.ca \ 
  "$(curl -sSL https://raw.githubusercontent.com/countable-web/dotfiles/master/install-slave.sh)"
```

## Extra Steps

To install docker.
```
./dotfiles/deploy/setup-docker
```

## Scripts
These dotfiles come bundled with several useful scripts.

### dump-pg
Dumps a postgres database (within docker-compose as nearly all our projects use), to `./db.sql`. _warning_ : Don't commit this sql file into GIT!

### restore-pg [sql file]
Restores an sql file into a dockerized postgres databse (as nearly all our projects use)

### dump-mongo
Same as above, but for mongo

### restore-mongo
Same as above but for mongo

### restore-db
If you have `awscli` set up, this will download the latest production database for your project and try to install it locally.

### cryptsend <file>
Sends a file to an encrypted cloud link you can download or share.

### gsync
Git sync - does an add, commit, pull, push from your repo folder.
_warning_ : Run `git status` first, and ensure you're not adding any files you don't want. Add those to your `.gitignore` file or delete them before running `gsync`

### perm
_warning_ : This script is recursive, so don't run it in the root directory or anywhere else ridiculous. Use it in your project folders only.

On any shared machine, Countable uses open group permissions for the "dev" group, which all users belong to. The setup script should create this group and add you to it. Once done, there's a catchall command for setting permissions so anyone in our group has full access. This is nearly always what we want, in order to be both simple and relatively secure.
```
cd <directory with permission issue>
perm
```

### Docker Aliases
  * `d` is aliased to `docker-compose`
  * `dx` is aliased to `docker-compose exec` and includes some terminal width fixes.
  * `dl` is allaseed to `docker-compose logs -f --tail=1000`, ie `dl web` to start tailing web logs.

# Tweaks

### Terminator Right Click to Paste
This is a suggested tweak for the terminal program. Probably only Clark cares about it.
```
sudo vi /usr/share/terminator/terminatorlib/terminal.py
```

search for on_buttonpress, and switch mouse indices

### Easily find countable.ca web addresses.
You may want to add - /etc/dhcp/dhclient.conf:append domain-name " countable.ca";

