#!/usr/bin/env bash

echo '\n'
echo "\tRun ${RED}Additional software Installation ${NC} script"
echo '\n'

###Get latest version of Sublime and add console call
wget -O ~/Downloads/SublimeTextBuild3126.dmg https://download.sublimetext.com/Sublime%20Text%20Build%203126.dmg
sudo hdiutil attach SublimeTextBuild3126.dmg
cp -a /Volumes/Sublime\ Text/Sublime\ Text.app /Applications
sudo hdiutil detach /Volumes/Sublime\ Text/
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime

echo "\r ${GREEN}EOF Additional software Installation Script ${NC}"