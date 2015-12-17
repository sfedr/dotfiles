dotfiles
========

OS X dotfiles settings

Inspired by https://github.com/holman/dotfiles and https://github.com/mathiasbynens/dotfiles


## Structure
Settings are organized on the per-app basis. So, settings for git, for example, will be kept in git folder.
A few 'special' folders exist in addition to that:

* osx - contains default settings for osx and basic osx applications (safari, terminal etc). osx/set-defaults.sh is ran as part of bootstrap process
* bin - contains scripts that will be added to the $PATH

Each folder might contain the following files:

* install.sh - should contain scripts to configure target application. For example, install npm or python modules.
* name.rc.symlink - this fill will be installed linked to .name.rc file in the users home directory. App settings will go there (for example, bash aliases or git settings)
* name.zsh - zsh configuration related to this app

git/gitconfig.symlink.template - template used to generate git configration as part of bootstrap process. Git user credentials will be filled in
Brewfile - contains applications/libraries to be installed
install-all.sh - runs install scripts for all applications

bootstrap.sh script exists to bootstrap new system or update previous.
While running, bootstrap.sh will perform the following steps:

1. Initializes global git config. If running the first time, the script will ask user for git credentials
2. For all app folders, for each file ending with .symlink new symlink will be created in the user folder pointing to this file.
3. bin/dot script is executed
	3.1 dot script will use homebrew to install configured application. Brewfile, located in the root of the project contains configurations for applications to be installed via brew or cask
	3.2 install-all.sh script is ran. This script will inspect all folders in the project and run install.sh file, if any

## New machine setup
Run bootstrap.sh script
