sudo apt update -y
sudo apt install apache2 -y
sudo apache2ctl -v
sudo systemctl status apache2

# only throw port 80
#sudo ufw allow 'Apache'
#sudo ufw status

#path with content  /var/www/
