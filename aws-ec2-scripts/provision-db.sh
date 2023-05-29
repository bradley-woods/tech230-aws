#!/bin/bash

# Update and upgrade packages
sudo apt-get update -y && sudo apt-get upgrade -y

# Download key to trusted key set
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927

# The key is used to download MongoDB source list
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# Ensure all packages are installed prior to installing MongoDB
sudo apt-get update -y && sudo apt-get upgrade -y

# Install MongoDB
sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20

# Edit /etc/mongod.conf file to change bindIp to app private IP
sudo sed -i "s/127.0.0.1/{{app-private-ip}}/" /etc/mongod.conf

# Restart then enable MongoDB
sudo systemctl restart mongod && sudo systemctl enable mongod

# ==============
# FOR USER DATA:
# ==============

#!/bin/bash

sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927

echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20

sudo sed -i "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf

sudo systemctl restart mongod && sudo systemctl enable mongod

# =============
# COMMUNITY AMI
# =============

# ami-0a7493ba2bc35c1e9
# ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20230424
