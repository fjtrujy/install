
./install-osx.sh

set -e

calabash-sandbox

#TODO: Test these somehow...
# if [ "$GEM_HOME" != "$HOME/.calabash/sandbox/Gems" ]; then
#   exit 1
# fi
#
#
# if [ "$GEM_HOME" == "$HOME/.calabash/sandbox/Gems" ]; then
#   exit 1
# fi
