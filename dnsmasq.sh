#!/usr/bin/env bash

echo "\tRun ${RED} DNS Masq configuration ${NC}\n"

mkdir $(brew --prefix)/etc
echo 'address=/.dev/127.0.0.1' > $(brew --prefix)/etc/dnsmasq.conf
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
sudo brew services dnsmasq restart
sudo mkdir /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'

echo "\tEOF ${GREEN} DNS Masq configuration ${NC}\n"