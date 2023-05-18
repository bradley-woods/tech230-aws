#!/bin/bash

# Update and upgrade packages
sudo apt-get update -y
sudo apt-get upgrade -y

echo "----Setting up NGINX Reverse Proxy----"

# Install nginx web server
sudo apt-get install nginx -y

# Replace default config file
echo "
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;

    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    location /posts {
        proxy_pass http://localhost:3000/posts;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}" | sudo tee /etc/nginx/sites-available/default

# Restart nginx web server
sudo systemctl restart nginx

# Keep it running on reboot
sudo systemctl enable nginx

echo "----Setting up NodeJS App----"

# Install app dependencies
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo npm install pm2 -g

# Add database host IP info to .bashrc
echo -e "\nexport DB_HOST=mongodb://1:27017/posts" | sudo tee -a .bashrc
source .bashrc

# Get repo with app folder


# Install app and run the app
cd ~/app
npm install

# Seed the database
node seeds/seed.js

# Start th app
pm2 stop app.js
pm2 start app.js --update-env