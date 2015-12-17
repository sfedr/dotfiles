#!/bin/sh
#
# Sublime Text
#
# This installs Package manager for Sublime Text
# based on http://chrisarcand.com/sublime-text-settings-and-dotfiles/

# Check for Homebrew
if test $(which subl)
then
	SUBLIME_ROOT="$HOME/Library/Application Support/Sublime Text 3"
	PACKAGES_PATH="$SUBLIME_ROOT/Installed Packages"

	if [ ! -f "$PACKAGES_PATH/Package Control.sublime-package" ]; 
	then
		echo "  Installing Package manager for Sublime Text."

		# Download package manager into 'Installed Packages folder for Sublime Text'
		wget 'https://packagecontrol.io/Package%20Control.sublime-package' -P "$PACKAGES_PATH"
	fi

	# symlink User package settings to this directory
	echo "  Linking user settings."
	ROOT_DIR=$(pwd -P)
	USER_PATH="$SUBLIME_ROOT/Packages/User"
	rm -rf "$USER_PATH"
	ln -s "$ROOT_DIR/sublime/User" "$USER_PATH"

	# refer to https://packagecontrol.io/docs/syncing for details
	echo "  Launch SublimeText and it will install correct packages"
fi

exit 0
