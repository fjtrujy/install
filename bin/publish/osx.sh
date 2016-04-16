#!/usr/bin/env bash

function banner {
  echo ""
  echo "$(tput setaf 5)######## $1 #######$(tput sgr0)"
  echo ""
}

function info {
  echo "$(tput setaf 2)INFO: $1$(tput sgr0)"
}

function error {
  echo "$(tput setaf 1)ERROR: $1$(tput sgr0)"
  exit $2
}

#usage: validate_cmd <exit_code> <action_message> <error_code_if_unsuccessful>
function validate_cmd {
  if [ $1 -ne 0 ]; then
    error "Error $2" $3
  fi
}

banner "Updating Calabash Sandbox Gems"
info "If you're not a maintainer, don't run this script!"

VERSION_LINE=`cat calabash-sandbox | grep SCRIPT_VERSION=`
VERSION=`echo $VERSION_LINE | cut -d= -f2 | cut -d\" -f2 | cut -d\" -f1`
MAJOR=`echo $VERSION | cut -d. -f1`
MINOR=`echo $VERSION | cut -d. -f2`
SUB=`echo $VERSION | cut -d. -f3`
SUB=$(($SUB + 1))
NEW_VERSION="$MAJOR.$MINOR.$SUB"
banner "Updating sandbox version to $NEW_VERSION"

sed -i .bak "s/${VERSION}/${NEW_VERSION}/" calabash-sandbox

info "Retrieving Gemfile"
SANDBOX="${HOME}/.calabash/sandbox"
cp "./Gemfile.OSX" "${SANDBOX}/Gemfile"

validate_cmd $? "copying Gemfile.OSX" 10

if [ ! -d "${SANDBOX}" ]; then
  error "Sandbox dir does note exist! Make sure you have a sandbox installation first." 11
fi
cd "${SANDBOX}"
GEMS_DIR=Gems

info "Installing Gems"
calabash-sandbox update
validate_cmd $? "installing gems" 3

info "Zipping Gems"
zip -qr CalabashGems.zip $GEMS_DIR
validate_cmd $? "zipping gems" 4

banner "Testing S3 Connection"

info "Verifying Credentials"
aws s3 ls | grep "calabash-files"
validate_cmd $? "verifying credentials. If you are a maintainer and don't have creds, \
you should know who to talk to in order to get them." 6

info "Uploading CalabashGems.zip to S3. This will take a while. Be patient, grasshopper"
aws s3 cp CalabashGems.zip s3://calabash-files/CalabashGems.zip
validate_cmd $? "uploading CalabashGems.zip to S3" 7

info "Cleaning Up"
rm -rf CalabashGems.zip
validate_cmd $? "cleaning up" 9

info "All done. Please commit the latest 'calabash-sandbox' file so that users \
will see the updated version number."

banner "SUCCESS"
