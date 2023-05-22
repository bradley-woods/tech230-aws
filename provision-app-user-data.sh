#!/bin/bash

sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install nginx -y

sudo sed -i "s/try_files \$uri \$uri\/ =404;/proxy_pass http:\/\/localhost:3000\/;/" /etc/nginx/sites-available/default

sudo sed -i "s/# pass PHP scripts to FastCGI server/location \/posts {\n\t\tproxy_pass http:\/\/localhost:3000\/posts;\n\t}/" /etc/nginx/sites-available/default

sudo systemctl restart nginx && sudo systemctl enable nginx

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

sudo apt-get install nodejs -y

sudo npm install pm2 -g

echo -e "\nexport DB_HOST=mongodb://192.168.10.150:27017/posts" >> ~/.bashrc

source ~/.bashrc

git clone https://github.com/bradley-woods/app.git ~/app

cd ~/app

sudo npm install

node seeds/seed.js

pm2 start app.js --update-env

pm2 restart app.js --update-env