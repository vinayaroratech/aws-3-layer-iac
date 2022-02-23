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

# Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html