### Configure Mac OS
echo '###'
echo 'Configure dock and show hidden files and files extension'
echo '###'
defaults write com.apple.finder AppleShowAllFiles YES; # show hidden files
defaults write com.apple.dock persistent-apps -array; # remove icons in Dock
defaults write com.apple.dock tilesize -int 36; # smaller icon sizes in Dock
defaults write com.apple.dock autohide -bool true; # turn Dock auto-hidng on
defaults write com.apple.dock autohide-delay -float 0; # remove Dock show delay
defaults write com.apple.dock autohide-time-modifier -float 0; # remove Dock show delay
defaults write NSGlobalDomain AppleShowAllExtensions -bool true; # show all file extensions

killall Finder
/System/Library/CoreServices/Finder.app


### Install x-code
echo '###'
echo 'Install X-Code required for Brew'
echo '###'
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
PROD=$(softwareupdate -l |
  grep "\*.*Command Line" |
  head -n 1 | awk -F"*" '{print $2}' |
  sed -e 's/^ *//' |
  tr -d '\n')
softwareupdate -i "$PROD" -v;

###install Brew
echo '###'
echo 'Install Brew Package manager'
echo '###'
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

### Add brew packages repositories
echo '###'
echo 'Add Packages required for all devs'
echo '###'
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/php
brew tap homebrew/apache

### Brew update
echo '###'
echo 'Brew Update'
echo '###'
brew update


echo '###'
echo 'Install required packages'
echo '###'
brew install dnsmasq
brew install httpd24 --with-privileged-ports --with-http2
brew install php70 --with-apache
brew install mariadb100
brew install php70-memcached
brew install memcached
brew install git
brew install wget

### Configure Apache
echo '###'
echo 'Remove default Apache'
echo '###'
sudo apachectl stop
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

echo '###'
echo 'Configure new Apache'
echo '###'
sudo cp -v /usr/local/Cellar/httpd24/2.4.23_2/homebrew.mxcl.httpd24.plist /Library/LaunchDaemons
sudo chown -v root:wheel /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist
sudo chmod -v 644 /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist
sudo brew services restart httpd24

### Configure DNS Masq
echo '###'
echo 'Configure DNS Masq'
echo '###'
mkdir $(brew --prefix)/etc
echo 'address=/.dev/127.0.0.1' > $(brew --prefix)/etc/dnsmasq.conf
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
sudo brew services dnsmasq restart
sudo mkdir /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'

### Copy configs files
echo '###'
echo 'Restart all services'
echo '###'
brew services restart --all

echo '###'
echo 'Install Composer'
echo '###'
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "
    if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') {
        echo 'Installer verified';
    } else {
        echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;
    "
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo chmod +x /usr/local/bin/composer
php -r "unlink('composer-setup.php');"


echo '###'
echo 'Create work dir structure'
echo '###'
mkdir ~/Work
echo 'export PATH=$(brew --prefix homebrew/php/php70)/bin:$PATH:$HOME/bin:/usr/local/sbin:~/.composer/vendor/bin' >> ~/.bash_profile
cp ~/Downloads/installdev/configs/dotfiles/.bash* ~/
cp ~/Downloads/installdev/configs/dotfiles/.git* ~/

echo '###'
echo 'Install NodeJs'
echo '###'
wget -O ~/Downloads/node-v4.6.1.pkg https://nodejs.org/dist/v4.6.1/node-v4.6.1.pkg
sudo installer -pkg node-v4.6.1.pkg -target /


echo '###'
echo 'Install Subline 3'
echo '###'
wget -O ~/Downloads/SublimeTextBuild3126.dmg https://download.sublimetext.com/Sublime%20Text%20Build%203126.dmg
sudo hdiutil attach SublimeTextBuild3126.dmg
cp -a /Volumes/Sublime\ Text/Sublime\ Text.app /Applications
sudo hdiutil detach /Volumes/Sublime\ Text/

echo '###'
echo 'NPM Install globaly gulp and bower'
echo '###'
npm update
npn install -g gulp bower

mkdir /usr/local/var/www/test
touch /usr/local/var/www/test/index.html

echo '
<html><body><h1>Hello World!!!</h1><?php phpinfo(); ?></body></html>
' > /usr/local/var/www/test/index.html

echo '

<FilesMatch .php$|.html>
    SetHandler application/x-httpd-php
</FilesMatch>
Include /usr/local/etc/apache2/2.4/extra/httpd-vhosts.conf

' >> /usr/local/etc/apache2/2.4/httpd.conf

echo '
<VirtualHost *:80>
    ServerAdmin admin@localhost
    DocumentRoot "/usr/local/var/www/test/”
    ServerName test.dev
    ErrorLog "/usr/local/var/log/apache2/test.dev-error_log"
    CustomLog "/usr/local/var/log/apache2/test.dev-access_log" common
</VirtualHost>

' > /usr/local/etc/apache2/2.4/extra/httpd-vhosts.conf

sudo echo '127.0.0.1    test.dev' > /private/etc/hosts

ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime

brew doctor