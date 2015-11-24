#!/bin/bash

#we need this for our bundle / gem commands
export GEM_HOME="$HOME/.calabash/sandbox/Gems"

CALABASH_RUBIES_HOME="$HOME/.calabash/sandbox/Rubies"
GEM="$HOME/.calabash/sandbox/Rubies/2.0.0-p195/bin/gem"
SANDBOX="$HOME/.calabash/sandbox"

#Don't overwrite the sandbox if it already exists
if [ -d "$SANDBOX" ]; then
  echo "Sandbox already exists! If you want to overwrite, first delete $SANDBOX"
  exit 1
fi

mkdir -p "$GEM_HOME"
mkdir -p "$HOME/.calabash/sandbox/Rubies"

#Download Ruby
echo "Preparing Ruby..."
curl -L -O --fail https://s3-eu-west-1.amazonaws.com/calabash-files/2.0.0-p195.zip 2>/dev/null
unzip -qo "2.0.0-p195.zip" -d "$CALABASH_RUBIES_HOME"
rm "2.0.0-p195.zip"

#Download the Sandbox Script
echo "Preparing sandbox..."
curl -L -O --fail https://s3-eu-west-1.amazonaws.com/calabash-files/calabash-sandbox 2>/dev/null
chmod a+x calabash-sandbox
mv calabash-sandbox /usr/local/bin

#Download the basic Gemfile with calabash-cucumber, calabash-android, and xamarin-test-cloud
curl -L -O --fail https://s3-eu-west-1.amazonaws.com/calabash-files/Gemfile.Basic 2>/dev/null
mv Gemfile.Basic "$SANDBOX/Gemfile"

#Download the gems and their dependencies
echo "Installing gems..."
$GEM install bundler --no-ri --no-rdoc
(cd "$HOME/.calabash/sandbox"; bundle install)

echo "Done!"
echo -e "Execute '\033[0;32msource calabash-sandbox start\033[00m' to get started!"
echo
