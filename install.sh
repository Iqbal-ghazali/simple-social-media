#!/bin/bash
set -e

echo "⏳ Installing npm packages..."
npm install

echo "▶️ Running npm build (non-watch mode)..."
npm run build

echo "💡 Installing composer dependencies..."
composer install

echo "📄 Copying .env file..."
cp .env.example .env

echo "🔑 Generating app key..."
php artisan key:generate

echo "⚙️ Setting DB config..."
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=172.17.0.2/g' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/g' .env

echo "🛠 Migrating and seeding database..."
php artisan migrate
php artisan db:seed

echo "🔗 Creating storage link..."
php artisan storage:link
