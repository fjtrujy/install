
./install-osx.sh

set -e

DROID=$( { echo "calabash-android version >&2" |  calabash-sandbox 1>/dev/null; } 2>&1)
IOS=$( { echo "calabash-ios version >&2" | calabash-sandbox 1>/dev/null; } 2>&1)
gem_home=$( { echo "echo \$GEM_HOME >&2" | calabash-sandbox 1>/dev/null; } 2>&1)

if [ "${DROID}" != "0.5.15" ]; then
  echo "calabash-android version ($DROID) should be 0.15.5"
  exit 1
elif [ "${IOS}" != "0.16.4" ]; then
  echo "calabash-ios version ($IOS) should be 0.16.4"
  exit 2
elif [ "${gem_home}" != "${HOME}/.calabash/sandbox/Gems" ]; then
  echo "Gem Home should be ${HOME}/.calabash/sandbox/Gems; Got $gem_home"
  exit 3
elif [ "${gem_home}" == "${GEM_HOME}" ]; then
  echo "Sandbox gem home ($gem_home) should be different than system gem home ($GEM_HOME)"
  exit 4
fi
