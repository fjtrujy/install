#!/usr/bin/env bash

if [ "$(uname -s)" != "Darwin" ]; then
  echo "Calabash-sandbox only runs on Mac OSX"
  exit 1
fi

export GEM_HOME="${HOME}/.calabash/sandbox/Gems"
CALABASH_RUBIES_HOME="${HOME}/.calabash/sandbox/Rubies"
CALABASH_RUBY_VERSION="2.1.5-p273"
SANDBOX="${HOME}/.calabash/sandbox"
CALABASH_SANDBOX="calabash-sandbox"

#Don't auto-overwrite the sandbox if it already exists
if [ -d "${SANDBOX}" ]; then
  echo "Sandbox already exists! Do you want to overwrite? (y/n)"
  read -n 1 -s ANSWER
  if [ "${ANSWER}" != "y" ]; then
    exit 0
  fi
fi

mkdir -p "$GEM_HOME"
mkdir -p "${HOME}/.calabash/sandbox/Rubies"

#Download Ruby
echo "Preparing Ruby ${CALABASH_RUBY_VERSION}..."

curl -o \
  "${CALABASH_RUBY_VERSION}.zip" \
  --progress-bar https://s3-eu-west-1.amazonaws.com/calabash-files/2.1.5-p273.zip

unzip -qo "${CALABASH_RUBY_VERSION}.zip" -d "${CALABASH_RUBIES_HOME}"
rm "${CALABASH_RUBY_VERSION}.zip"

#Download the gems and their dependencies
echo "Installing gems, this may take a little while..."

CALABASH_GEMS_FILE="CalabashGems.zip"
if [ "${DEBUG}" == 1 ]; then
  CALABASH_GEMS_FILE="calabash-sandbox/dev/CalabashGems.zip"
  echo "[DEBUG]: Using calabash gems file: ${CALABASH_GEMS_FILE}"
fi

curl -o \
  "CalabashGems.zip" \
  --progress-bar https://s3-eu-west-1.amazonaws.com/calabash-files/${CALABASH_GEMS_FILE}

unzip -qo "CalabashGems.zip" -d "${SANDBOX}"
rm "CalabashGems.zip"

#ad hoc Gemfile
echo "source 'https://rubygems.org'" > "${SANDBOX}/Gemfile"
echo "gem 'calabash-cucumber', '>= 0.17.0', '< 1.0'" >> "${SANDBOX}/Gemfile"
echo "gem 'calabash-android', '>= 0.5.15', '< 1.0'" >> "${SANDBOX}/Gemfile"
echo "gem 'xamarin-test-cloud', '~> 1.0'" >> "${SANDBOX}/Gemfile"

#Download the Sandbox Script
echo "Preparing sandbox..."

curl -L -O \
  --progress-bar https://s3-eu-west-1.amazonaws.com/calabash-files/calabash-sandbox

chmod a+x $CALABASH_SANDBOX
mv $CALABASH_SANDBOX /usr/local/bin
if [ $? -ne 0 ]; then
  CALABASH_SANDBOX="./calabash-sandbox"
  echo -e "\033[0;33m[Warning]:\033[00m Unable to install globally, /usr/local/bin is not writeable"
  echo "To install globally, run this command:"
  echo ""
  echo -e "'\033[0;33msudo mv calabash-sandbox /usr/local/bin\033[00m'"
fi

DROID=$( { echo "calabash-android version 1>&2" |  $CALABASH_SANDBOX 1>/dev/null; } 2>&1)
IOS=$( { echo "calabash-ios version 1>&2" | $CALABASH_SANDBOX 1>/dev/null; } 2>&1)
TESTCLOUD=$( { echo "test-cloud version 1>&2" | $CALABASH_SANDBOX 1>/dev/null; } 2>&1)

echo "Done! Installed:"
echo -e "\033[0;33mcalabash-ios:       $IOS"
echo "calabash-android:   $DROID"
echo -e "xamarin-test-cloud: $TESTCLOUD\033[00m"
echo -e "Execute '\033[0;32m$CALABASH_SANDBOX\033[00m' to get started! "
echo
