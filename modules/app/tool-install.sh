#!/bin/bash -xe
sudo apt update
sudo apt upgrade -y
sudo apt install -y nginx nano
sudo ufw app list
sudo ufw allow 'Nginx Full'
sudo ufw status
sudo systemctl enable nginx
sudo systemctl start nginx
sudo echo '<h1>Welcome to Symba - APP-1</h1>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/app1
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to symba - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
# Create the docker group.
sudo groupadd docker
# Add your user to the docker group.
sudo usermod -aG docker $USER
# On Linux, you can also run the following command to activate the changes to groups:
newgrp docker
# Configure Docker to start on boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
# Install node 10x
curl https://gist.githubusercontent.com/vinaykarora/85a6d0e86ada7ff57498ebc0ac1a0279/raw/08ebbf0f45d9a28b5d0d92ebe7676e2a042d6e2d/install-node-10x-npm-on-ubuntu-1804.sh | sudo bash 

# Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html