# Install MySql

1. Run MySqlInstall.sh
2. `sudo mysql`
3. mysql>`ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';`
4. mysql>`exit`
5. `sudo mysql_secure_installation`
6. y y y y
7. `sudo systemctl status mysql`
8. `mysql -u root -p` 
9. mysql> `ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;`
10. mysql>`exit`

# Create user 

1. `sudo mysql`
2. mysql>`CREATE USER 'user1'@'%' IDENTIFIED BY 'password';`  % mean that you can connect from all ip
3. mysql>`GRANT ALL PRIVILEGES ON my_timeweb.* TO 'user1'@'%';` gain all right to user
4. mysql>`CREATE DATABASE IF NOT EXISTS database_name;` 
5. mysql>`CREATE TABLE Testtable ( id INT, value VARCHAR(255));`
6. mysql>`INSERT Testtable(id, value) VALUES('1', 'test1');`

[Install MySql actual 07.2023](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04)

/etc/php/7.4/cli
925 extension=mysqli

# Open port 3306(mysql port) for remote connection 

1. Find config file MySQL 
PATH: `/etc/mysql/mysql.conf.d/mysqld.cnf`

2. Commit this line `#bind-address = 127.0.0.1`

3. Reboot server
`sudo systemctl restart mysql`
`sudo systemctl status mysql`

# Connect DB with apach2

[LAMP](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-22-04)