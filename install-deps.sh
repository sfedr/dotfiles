# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

# https://github.com/rupa/z
HELPERS_PATH=~/"Projects/helpers"
git clone https://github.com/rupa/z.git $HELPERS_PATH/
chmod +x $HELPERS_PATH/z/z.sh
# also consider moving over your current .z file if possible. it's painful to rebuild :)
# z binary is already referenced from .bash_profile

# Set symlink for Sublime Text 2
ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl