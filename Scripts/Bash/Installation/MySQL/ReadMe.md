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

[Install MySql actual 07.2023](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04)
