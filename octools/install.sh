#!/bin/sh
# configures octools

export PROJECTS_ROOT=~/Projects

echo "Checking for xcode command line tools..."
if ! pkgutil --pkg-info=com.apple.pkg.CLTools_Executables; then
    echo "Installing xcode command line tools..."
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    xcodeproduct=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
    sudo softwareupdate -i "${xcodeproduct}" -v
    rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

    if ! pkgutil --pkg-info=com.apple.pkg.CLTools_Executables; then
        echo "Failed to install the xcode command line tools with softwareupdate"
        echo "Trying another approach... A dialog should appear: just click 'Install'"
        echo "Once done, please re-run this script."
        xcode-select --install
        exit 1
    fi
fi

set -e

echo "Cloning octools git repo..."

# checkout or update octools
export OCTOOLS_ROOT=$PROJECTS_ROOT/octools
if test -d "$OCTOOLS_ROOT"; then
    cd "$OCTOOLS_ROOT"
    git pull
else
    mkdir -p "$PROJECTS_ROOT"
    git clone https://stash.corp.netflix.com/scm/ot/octools.git "$OCTOOLS_ROOT"
    cd "$OCTOOLS_ROOT"
fi

echo "Creating base octools directories..."
mkdir -p ~/.oc
mkdir -p ~/.oc/backup
mkdir -p ~/.oc/python-envs
mkdir -p ~/.oc/run

echo "Checking for homebrew..."
if ! test -f /usr/local/bin/brew; then
    echo "Installing homebrew..."
    ruby "$OCTOOLS_ROOT/setup/homebrew/install.rb"
fi

echo "Updating homebrew..."
brew update

# start bootstrapin'
if test -d /tmp/oc-bootstrap; then
    rm -rf /tmp/oc-bootstrap
fi
mkdir /tmp/oc-bootstrap
cd /tmp/oc-bootstrap

echo "Installing python from homebrew..."
brew install python
/usr/local/bin/pip install -U pip setuptools wheel virtualenv

echo "Creating a temporary venv..."
virtualenv /tmp/oc-bootstrap/venv
source /tmp/oc-bootstrap/venv/bin/activate
pip install -U pip setuptools wheel virtualenv
pip install PyYAML


echo "Installing our dependencies from homebrew..."
brew install $(python $OCTOOLS_ROOT/setup/packages.py $OCTOOLS_ROOT/setup/packages.yaml)

echo "Creating our octools venv..."

# switch to octools
if test -d ~/.oc/python-envs/oc; then
    rm -rf ~/.oc/python-envs/oc
fi

virtualenv ~/.oc/python-envs/oc
deactivate
source ~/.oc/python-envs/oc/bin/activate
pip install -U pip setuptools wheel virtualenv

echo "Installing python dependencies in the octools venv..."

cd $OCTOOLS_ROOT
pip install --trusted-host pypicloud.test.netflix.net -i https://pypicloud.test.netflix.net/pypi/ -r requirements.txt
python setup.py develop --no-deps

echo "Setting up your bash profile..."
export OC_REPO_PATH=$OCTOOLS_ROOT
./setup/setup base

echo "Refreshing commands..."
source ./shell/oc_bash_profile.sh
oc --autodiscover refresh -q

echo "All done"
