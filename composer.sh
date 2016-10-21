#!/usr/bin/env bash

echo '\n'
echo "\tRun ${RED} Composer Install ${NC}"
echo '\n'

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php ./composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo chmod +x /usr/local/bin/composer
php -r "unlink('composer-setup.php');"
composer self-update

echo "\tEOF ${GREEN} Composer Install ${NC}"