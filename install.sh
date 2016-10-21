
#!/usr/bin/env bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;31'

source ./macosConfigs.sh
source ./xcode.sh
source ./composer.sh
source ./brew.sh
source ./apache.sh
source ./dnsmasq.sh
source ./nodejs.sh
source ./additionalSoft.sh

mkdir ~/Work
echo 'export PATH=$(brew --prefix homebrew/php/php70)/bin:$PATH:$HOME/bin:/usr/local/sbin:~/.composer/vendor/bin' >> ~/.bash_profile
cp ~/Downloads/installdev/configs/dotfiles/.bash* ~/
cp ~/Downloads/installdev/configs/dotfiles/.git* ~/

brew services restart --all
brew doctor
open 'http://test.dev/'