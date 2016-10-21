#!/usr/bin/env bash

echo '\n'
echo "\tRun ${RED}Apache Installation ${NC} script"
echo '\n'

### Remove default apache
sudo apachectl stop
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

sudo cp -v /usr/local/Cellar/httpd24/2.4.23_2/homebrew.mxcl.httpd24.plist /Library/LaunchDaemons
sudo chown -v root:wheel /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist
sudo chmod -v 644 /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist

mkdir /usr/local/var/www/test
touch /usr/local/var/www/test/index.html

###Create test.dev page with PHP
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

echo "\tEOF ${GREEN}Apache Installation ${NC} script"