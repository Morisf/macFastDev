#!/usr/bin/env bash

echo '\n'
echo "\tRun ${RED}Node JS Installation ${NC} script"
echo '\n'

wget -O ~/Downloads/node-v4.6.1.pkg https://nodejs.org/dist/v4.6.1/node-v4.6.1.pkg
sudo installer -pkg node-v4.6.1.pkg -target /

npm update
npn install -g gulp bower

echo "\tEOF ${GREEN}Node JS Installation ${NC} script"
