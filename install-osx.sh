#!/bin/bash

CALABASH_GEM_HOME="$HOME/.calabash/sandbox/Gems"
CALABASH_RUBIES_HOME="$HOME/.calabash/sandbox/Rubies"
GEM="$HOME/.calabash/sandbox/Rubies/2.0.0-p195/bin/gem"

mkdir -p "$CALABASH_GEM_HOME"
mkdir -p "$HOME/.calabash/sandbox/Rubies"

echo "Preparing Ruby..."
curl -L -O --fail https://s3-eu-west-1.amazonaws.com/calabash-files/2.0.0-p195.zip 2>/dev/null
unzip -qo "2.0.0-p195.zip" -d "$CALABASH_RUBIES_HOME"
rm "2.0.0-p195.zip"

echo "Preparing sandbox..."
curl -L -O --fail https://s3-eu-west-1.amazonaws.com/calabash-files/calabash-sandbox 2>/dev/null
chmod a+x calabash-sandbox
mv calabash-sandbox /usr/local/bin

echo "Installing gems..."
GEM_HOME="$CALABASH_GEM_HOME" $GEM install calabash-cucumber -v 0.16.4 --no-ri --no-rdoc #reduce download time
GEM_HOME="$CALABASH_GEM_HOME" $GEM install calabash-android -v 0.5.14 --no-ri --no-rdoc #reduce download time
GEM_HOME="$CALABASH_GEM_HOME" $GEM install xamarin-test-cloud -v 1.1.2 --no-ri --no-rdoc #reduce download time

echo "Done!"
echo -e "Execute '\033[0;33msource calabash-sandbox start\033[00m' to get started!"
echo
