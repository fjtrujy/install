#!/usr/bin/env bash

function error {
  echo "$(tput setaf 1)ERROR: $1$(tput sgr0)"
  exit $2
}

# In the absence of a --no-input option, we need to clear an existing sandbox
# before we test on Jenkins, otherwise the test will block waiting for input.
#
# On Travis the directory will always be empty.
if [ ! -z "${JENKINS_HOME}" ]; then
  rm -rf "${HOME}/.calabash/sandbox"
fi

# Executing this test from ./ causes ./calabash-sandbox to be deleted (mv'ed)
# to /usr/local/bin - assuming it is writable.  Execute the script in tmp
# directory.
TMP_DIR=tmp/sandbox
rm -rf "${TMP_DIR}"
mkdir -p "${TMP_DIR}"
cp ./install-osx.sh "${TMP_DIR}"

cp -r bin/test/cucumber "${TMP_DIR}"

cd "${TMP_DIR}"

./install-osx.sh

set -e

IOS_EXPECTED_VERSION="0.19.1"
DROID_EXPECTED_VERSION="0.7.3"

DROID=$( { echo "calabash-android version >&2" |  calabash-sandbox 1>/dev/null; } 2>&1)
IOS=$( { echo "calabash-ios version >&2" | calabash-sandbox 1>/dev/null; } 2>&1)
gem_home=$( { echo "echo \$GEM_HOME >&2" | calabash-sandbox 1>/dev/null; } 2>&1)

echo "Testing calabash-android version"
if [ "${DROID}" != "${DROID_EXPECTED_VERSION}" ]; then
  error "calabash-android version ($DROID) should be $DROID_EXPECTED_VERSION" 1
fi

echo "Testing calabash-ios version"
if [ "${IOS}" != "${IOS_EXPECTED_VERSION}" ]; then
  error "calabash-ios version ($IOS) should be $IOS_EXPECTED_VERSION" 2
fi

echo "Ensuring sandbox GEM_HOME properly set"
if [ "${gem_home}" != "${HOME}/.calabash/sandbox/Gems" ]; then
  echo "Gem Home should be ${HOME}/.calabash/sandbox/Gems; Got $gem_home"
  exit 3
fi

if [ ! -z "${TRAVIS}" ]; then
  echo "Integration tests don't run on Travis."
  echo "Done!"
  exit 0
fi

git clone https://github.com/calabash/calabash-ios-server.git

cd calabash-ios-server
bundle install
make app-cal

mv Products/test-target/app-cal/LPTestTarget.app \
  ../cucumber

cd ../cucumber

mkdir -p results

# Fails silently.
#
# [ENV] cucumber [args]
# echo "$?" > exit.out
#
# exit.out is always 0
#
# Will have to rely on post-processing of results/cucumber.json
calabash-sandbox <<EOF
APP=./LPTestTarget.app cucumber --format pretty --format json -o results/cucumber.json
exit
EOF
