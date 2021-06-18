#!/bin/sh

/usr/local/bin/composer global require laravel/installer laravel/valet beyondcode/expose

$HOME/.composer/vendor/bin/valet install
