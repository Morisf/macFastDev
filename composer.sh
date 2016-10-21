#!/usr/bin/env bash

echo '\n'
echo "\tRun ${RED} Composer Install ${NC}"
echo '\n'

curl -sS https://getcomposer.org/installer | php
sudo mv ./composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
composer self-update

echo "\tEOF ${GREEN} Composer Install ${NC}"
