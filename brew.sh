#!/usr/bin/env bash

echo '\n'
echo "\tRun ${RED} Brew Installation ${NC} script"
echo '\n'

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/php
brew tap homebrew/apache

brew update

brew install dnsmasq
brew install httpd24 --with-privileged-ports --with-http2
brew install php70 --with-apache
brew install mariadb100
brew install php70-memcached
brew install memcached
brew install git
brew install wget

echo "\tEOF ${GREEN} Brew Installation ${NC}"