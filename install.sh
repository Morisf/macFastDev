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
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist

### Configure DNS Masq
echo '###'
echo 'Configure DNS Masq'
echo '###'
cd $(brew --prefix); mkdir etc; echo 'address=/.dev/127.0.0.1' > etc/dnsmasq.conf
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
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

