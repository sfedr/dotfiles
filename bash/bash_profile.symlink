# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Addd brew/cask installed tools to the path
export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# init z https://github.com/rupa/z
. ~/Projects/helpers/z/z.sh

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    source "$(brew --prefix)/etc/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# Thanks to @tmoitie, adds more tab completion for bash,
# also when hitting tab twice it will show a list.
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# http://stackoverflow.com/questions/13804382/how-to-automatically-run-bin-bash-login-automatically-in-the-embeded-termin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# oc tools exports and config
export OC_REPO_PATH=~/Projects/octools

# hive/hadoop
export HADOOP_HOME=/usr/local/Cellar/hadoop/2.5.0
export HIVE_HOME=export HIVE_HOME=/usr/local/Cellar/hive/0.13.1/libexec

# Java
export JAVA_HOME=/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/java
export CLASSPATH=.:$CLASSPATH

# Gradle/Nebula
export PATH=$PATH:$HOME/Projects/NEBULA/wrapper

source ${OC_REPO_PATH}/shell/oc_bash_profile.sh

# create function to init aws keys for base ami profile
function get_aws_creds_for_boto() {
  echo "Checking the credentials ..."
  if [[ -f ~/aws_creds.json ]]; then
    EXPIRATION=$(cat ~/aws_creds.json|jq -r '.Expiration'||:)
    let DIFF_IN_MINUTES=(`date +%s -d "${EXPIRATION}"`-`date +%s`)/60
    echo "Credentials are expiring in ${DIFF_IN_MINUTES} minutes"
    # From AWS: The application is granted the permissions for the actions and resources that you've defined for the role
    # through the security credentials associated with the role. These security credentials are temporary and we rotate them
    # automatically. We make new credentials available at least five minutes prior to the expiration of the old credentials.
    if [[ ${DIFF_IN_MINUTES} -gt 5 ]]; then
      echo "We're good. Nothing to do."
      return
    fi
  fi

  echo "Updating the credentials"
  ssh $(whoami)@awstest.netflix.com "/usr/local/bin/oq-ssh --region us-east-1 winston,0 \"curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/BaseIAMRole\"" > ~/aws_creds.json
  mkdir -p ~/.aws
  cat ~/aws_creds.json
  echo "[default]" > ~/.aws/credentials
  echo "aws_access_key_id = $(cat ~/aws_creds.json|jq -r '.AccessKeyId')" >> ~/.aws/credentials
  echo "aws_secret_access_key = $(cat ~/aws_creds.json|jq -r '.SecretAccessKey')" >> ~/.aws/credentials
  echo "aws_security_token = $(cat ~/aws_creds.json|jq -r '.Token')" >> ~/.aws/credentials
  echo ""
  echo "DONE."
}

#to install homebrew into /Applications
export HOMEBREW_CASK_OPTS="--appdir=/Applications"