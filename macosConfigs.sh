#!/bis/bash

echo '\n'
echo "\tRun ${RED} MacOs system configs updates ${NC}"
echo '\n'

defaults write com.apple.finder AppleShowAllFiles YES; # show hidden files
defaults write com.apple.dock persistent-apps -array; # remove icons in Dock
defaults write com.apple.dock tilesize -int 36; # smaller icon sizes in Dock
defaults write com.apple.dock autohide -bool true; # turn Dock auto-hidng on
defaults write com.apple.dock autohide-delay -float 0; # remove Dock show delay
defaults write com.apple.dock autohide-time-modifier -float 0; # remove Dock show delay
defaults write NSGlobalDomain AppleShowAllExtensions -bool true; # show all file extensions

killall Finder
open /System/Library/CoreServices/Finder.app

echo "\tEOF ${GREEN} MacOs system configs updates ${NC}"