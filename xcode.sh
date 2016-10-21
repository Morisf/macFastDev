#!/usr/bin/env bash

echo "\tRun ${RED}X-Code Installation ${NC} script"

touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
PROD=$(softwareupdate -l |
  grep "\*.*Command Line" |
  head -n 1 | awk -F"*" '{print $2}' |
  sed -e 's/^ *//' |
  tr -d '\n')
softwareupdate -i "$PROD" -v;
echo "\tEOF ${GREEN}X-Code Installation ${NC} script"
