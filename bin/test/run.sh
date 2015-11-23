#!/usr/bin/env bash

bin/test/rbenv.sh
bin/test/rvm.sh
bin/test/upgrade-version-1.0-install.sh
bin/test/previous-install-detected.sh
bin/test/clean-install.sh

if [ ! -z "${TRAVIS}" ]; then
  echo "Integration tests don't run on Travis."
  echo "Done!"
  exit 0
fi

CAL_GEMS="${PWD}/tmp/test/bin/test/clean-install.sh/.calabash/calabash-gems"
export GEM_HOME="${CAL_GEMS}"
export GEM_PATH="${CAL_GEMS}"
export PATH="${CAL_GEMS}/bin:${PATH}"

rm -rf calabash-ios-server
git clone https://github.com/calabash/calabash-ios-server.git

CAL_GEMS="${PWD}/tmp/test/bin/test/clean-install.sh/.calabash/calabash-gems"

# /usr/bin/ruby needs to come before rvm or rbenv
CAL_PATH="${CAL_GEMS}/bin:/usr/bin:/usr/local/bin"

echo "PATH= ${CAL_PATH}"
which ruby

which rbenv

hash -r

( cd calabash-ios-server && GEM_HOME="${CAL_GEMS}" \
  GEM_PATH="${CAL_GEMS}" \
  PATH="${CAL_PATH}" \
  bundle install )

( cd calabash-ios-server && GEM_HOME="${CAL_GEMS}" \
  GEM_PATH="${CAL_GEMS}" \
  PATH="${CAL_PATH}" \
  bundle show xcpretty )

( cd calabash-ios-server && GEM_HOME="${CAL_GEMS}" \
  GEM_PATH="${CAL_GEMS}" \
  PATH="${CAL_PATH}" \
  make clean )

( cd calabash-ios-server && GEM_HOME="${CAL_GEMS}" \
  GEM_PATH="${CAL_GEMS}" \
  PATH="${CAL_PATH}" \
  bin/ci/jenkins/make-ipa.sh )

( cd calabash-ios-server && GEM_HOME="${CAL_GEMS}" \
  GEM_PATH="${CAL_GEMS}" \
  PATH="${CAL_PATH}" \
  bin/test/test-cloud.rb )

( cd calabash-ios-server && GEM_HOME="${CAL_GEMS}" \
  GEM_PATH="${CAL_GEMS}" \
  PATH="${CAL_PATH}" \
  bin/test/cucumber.rb )

