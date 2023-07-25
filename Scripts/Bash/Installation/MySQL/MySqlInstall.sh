sudo apt update -y
sudo apt upgrade -y
sudo apt install mysql-server -y
sudo systemctl start mysql.service
mysql --version
#sudo mysql_secure_installation
#sudo systemctl status mysql