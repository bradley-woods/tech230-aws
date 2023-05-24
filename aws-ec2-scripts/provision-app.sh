#!/bin/bash

# Update and upgrade packages
sudo apt-get update -y && sudo apt-get upgrade -y

# Install nginx web server
sudo apt-get install nginx -y

# Replace the line "try_files $uri $uri/ =404;" in the default nginx configuration file with "proxy_pass http://localhost:3000/;"
sudo sed -i "s/try_files \$uri \$uri\/ =404;/proxy_pass http:\/\/localhost:3000\/;/" /etc/nginx/sites-available/default

# Replace the line "# pass PHP scripts to FastCGI server" in the default nginx configuration file with a new location block for /posts containing "proxy_pass http://localhost:3000/posts;"
sudo sed -i "s/# pass PHP scripts to FastCGI server/location \/posts {\n\t\tproxy_pass http:\/\/localhost:3000\/posts;\n\t}/" /etc/nginx/sites-available/default

# Start and enable Nginx web server
sudo systemctl restart nginx && sudo systemctl enable nginx

# Install app dependencies
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

sudo apt-get install nodejs -y

sudo npm install pm2 -g

# Add database host IP as a global environment variable
export DB_HOST=mongodb://192.168.10.150:27017/posts

# Get repo with app folder
git clone https://github.com/bradley-woods/app.git ~/app

# Install the app
cd ~/app

sudo npm install

# Seed the database
node seeds/seed.js

# Start/restart the app (if already running)
pm2 start app.js --update-env

pm2 restart app.js --update-env

# ==============
# FOR USER DATA:
# ==============

#!/bin/bash

sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install nginx -y

sudo sed -i "s/try_files \$uri \$uri\/ =404;/proxy_pass http:\/\/localhost:3000\/;/" /etc/nginx/sites-available/default

sudo sed -i "s/# pass PHP scripts to FastCGI server/location \/posts {\n\t\tproxy_pass http:\/\/localhost:3000\/posts;\n\t}/" /etc/nginx/sites-available/default

sudo systemctl restart nginx && sudo systemctl enable nginx

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

sudo apt-get install nodejs -y

sudo npm install pm2 -g

export DB_HOST=mongodb://10.0.3.221:27017/posts

git clone https://github.com/bradley-woods/app.git /home/ubuntu/app

cd /home/ubuntu/app

sudo npm install

node seeds/seed.js

pm2 start app.js --update-env

pm2 restart app.js --update-env