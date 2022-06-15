#!/bin/bash
set -e

echo "Deployment started ..."

# Enter maintenance mode or return true
# if already is in maintenance mode
(php artisan down) || true
# remove old env ----------------
rm -rf .env


echo 'old env has discard Successfuly'
# Pull the latest version of the app
git stash
git config core.sshCommand 'ssh -i ~/.ssh/cpanel'
git pull 
#commit
echo 'Start Copy Env Vaibale'
cp .env.example .env
echo 'Files Is Copyed success'

php artisan key:generate
echo 'key genrate'
# Install composer dependencies
composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

# Clear the old cache
php artisan clear-compiled

# Recreate cache
php artisan optimize

# Compile npm assets
# npm run prod

# Run database migrations
php artisan queue:table

php artisan migrate:fr #--force

# Exit maintenance mode
php artisan up
echo 'server is avaliable'

echo "Deployment finished!"

echo 'Deployment to DevLopemt Server Was Done'
