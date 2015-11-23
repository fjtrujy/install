
./install-osx.sh
source calabash-sandbox start

if [ "$GEM_HOME" != "$HOME/.calabash/sandbox/Gems" ]; then
  exit 1
fi

source calabash-sandbox stop

if [ "$GEM_HOME" == "$HOME/.calabash/sandbox/Gems" ]; then
  exit 1
fi
