#!/bin/bash

set -e

export GEM_HOME="${HOME}/.calabash/sandbox/Gems"
CALABASH_RUBIES_HOME="${HOME}/.calabash/sandbox/Rubies"
GEM="$HOME/.calabash/sandbox/Rubies/2.0.0-p195/bin/gem"
SANDBOX="$HOME/.calabash/sandbox"

#Don't auto-overwrite the sandbox if it already exists
if [ -d "$SANDBOX" ]; then
  echo "Sandbox already exists! Do you want to overwrite? (y/n)"
  read -n 1 -s ANSWER
  if [ $ANSWER == "y" ]; then
    rm -rf "${HOME}/.calabash/sandbox"
  else
    exit 0
  fi
fi

mkdir -p "$GEM_HOME"
mkdir -p "$HOME/.calabash/sandbox/Rubies"

#Download Ruby
echo "Preparing Ruby..."
curl -o "2.0.0-p195.zip" --progress-bar https://s3-eu-west-1.amazonaws.com/calabash-files/2.0.0-p195.zip
unzip -qo "2.0.0-p195.zip" -d "${CALABASH_RUBIES_HOME}"
rm "2.0.0-p195.zip"

#Download the Sandbox Script
echo "Preparing sandbox..."
(cd /usr/local/bin && curl -L -O --fail https://s3-eu-west-1.amazonaws.com/calabash-files/calabash-sandbox 2>/dev/null && chmod a+x calabash-sandbox)

#Download the gems and their dependencies
echo "Installing gems, this may take a little while..."
$GEM install bundler --no-rdoc --no-ri --bindir ${GEM_HOME}/bin

#ad hoc Gemfile
echo "source 'https://rubygems.org'" > "${SANDBOX}/Gemfile"
echo "gem 'calabash-cucumber', '>= 0.16.4', '< 1.0'" >> "${SANDBOX}/Gemfile"
echo "gem 'calabash-android', '>= 0.5.15', '< 1.0'" >> "${SANDBOX}/Gemfile"
echo "gem 'xamarin-test-cloud', '~> 1.0'" >> "${SANDBOX}/Gemfile"

#TODO Do we need to clear defaults for bundler...?
cd "${SANDBOX}" && ${GEM_HOME}/bin/bundle install --path=${GEM_HOME} --binstubs=${GEM_HOME}/bin

echo "Done!"
echo -e "Execute '\033[0;32m calabash-sandbox \033[00m' to get started! "
echo
