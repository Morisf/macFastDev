### Install x-code
echo '###'
echo 'Install X-Code required for Brew'
echo '###'
xcode-select --install

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
brew install git

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
sudo brew services httpd24 restart

### Configure DNS Masq
echo '###'
echo 'Configure DNS Masq'
echo '###'
cd $(brew --prefix); mkdir etc; echo 'address=/.dev/127.0.0.1' > etc/dnsmasq.conf
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
sudo brew services dnsmasq restart
sudo mkdir /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'

### Copy configs files
echo '###'
echo 'Copy predefined APACHE httpd.conf'
echo '###'
cp ./configs/apache/httpd.conf /usr/local/etc/apache2/2.4/httpd.conf

### Copy configs files
echo '###'
echo 'Restart all services'
echo '###'
brew services restart --all

echo '###'
echo 'Create work dir structure'
echo '###'
mkdir ~/Work
echo "<h1>My User Web Root</h1>" > ~/Work/index.html

echo 'export PATH=$(brew --prefix homebrew/php/php70)/bin:$PATH:$HOME/bin:/usr/local/sbin:~/.composer/vendor/bin' >> ~/.bash_profile

echo '###'
echo 'Install Composer'
echo '###'
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo chmod +x /usr/local/bin/composer
php -r "unlink('composer-setup.php');"
