#!/usr/bin/env bash

if [ "$(uname -s)" != "Darwin" ]; then
  echo "Calabash-sandbox only runs on Mac OSX"
  exit 1
fi

# set -e

export GEM_HOME="${HOME}/.calabash/sandbox/Gems"
CALABASH_RUBIES_HOME="${HOME}/.calabash/sandbox/Rubies"
CALABASH_RUBY_VERSION="2.1.5-p273"
SANDBOX="$HOME/.calabash/sandbox"

if [ ! -w "/usr/local/bin" ]; then
  echo "/usr/local/bin is not writeable'"
  echo -e "Please execute '\033[0;33msudo chmod a+w /usr/local/bin\033[00m' and try again"
  echo "If you are not an admin user, contact a system administrator"
  exit 2
fi

#Don't auto-overwrite the sandbox if it already exists
if [ -d "$SANDBOX" ]; then
  echo "Sandbox already exists! Do you want to overwrite? (y/n)"
  read -n 1 -s ANSWER
  if [ $ANSWER != "y" ]; then
    exit 0
  fi
fi

mkdir -p "$GEM_HOME"
mkdir -p "$HOME/.calabash/sandbox/Rubies"

#Download Ruby
echo "Preparing Ruby ${CALABASH_RUBY_VERSION}..."
curl -o "${CALABASH_RUBY_VERSION}.zip" --progress-bar https://s3-eu-west-1.amazonaws.com/calabash-files/2.1.5-p273.zip
unzip -qo "${CALABASH_RUBY_VERSION}.zip" -d "${CALABASH_RUBIES_HOME}"
rm "${CALABASH_RUBY_VERSION}.zip"

#Download the Sandbox Script
echo "Preparing sandbox..."
(cd /usr/local/bin && curl -L -O --fail https://s3-eu-west-1.amazonaws.com/calabash-files/calabash-sandbox 2>/dev/null && chmod a+x calabash-sandbox)

# #Download the gems and their dependencies
echo "Installing gems, this may take a little while..."
curl -o "CalabashGems.zip" --progress-bar https://s3-eu-west-1.amazonaws.com/calabash-files/CalabashGems.zip
unzip -qo "CalabashGems.zip" -d "${SANDBOX}"
rm "CalabashGems.zip"

#ad hoc Gemfile
echo "source 'https://rubygems.org'" > "${SANDBOX}/Gemfile"
echo "gem 'calabash-cucumber', '>= 0.16.4', '< 1.0'" >> "${SANDBOX}/Gemfile"
echo "gem 'calabash-android', '>= 0.5.15', '< 1.0'" >> "${SANDBOX}/Gemfile"
echo "gem 'xamarin-test-cloud', '~> 1.0'" >> "${SANDBOX}/Gemfile"

DROID=$( { echo "calabash-android version >&2" |  calabash-sandbox 1>/dev/null; } 2>&1)
IOS=$( { echo "calabash-ios version >&2" | calabash-sandbox 1>/dev/null; } 2>&1)
TESTCLOUD=$( { echo "test-cloud version >&2" | calabash-sandbox 1>/dev/null; } 2>&1)

echo "Done! Installed:"
echo -e "\033[0;33mcalabash-ios:       $IOS"
echo "calabash-android:   $DROID"
echo -e "xamarin-test-cloud: $TESTCLOUD\033[00m"
echo -e "Execute '\033[0;32mcalabash-sandbox\033[00m' to get started! "
echo
