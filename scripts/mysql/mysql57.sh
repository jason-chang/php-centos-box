#!/usr/bin/env bash

# 安装 MySQL
yum install -y mysql mysql-client mysql-server mysql-devel --enablerepo=mysql57-community

# 建立 环境标识
touch /home/vagrant/.env/mysql57

systemctl enable mysqld.service
systemctl start mysqld.service

# 配置 MySQL 密码生存时间
sed -i '$a default_password_lifetime=0' /etc/my.cnf


# 配置 MySQL 字符集
sed -i '$a character_set_server=utf8' /etc/my.cnf


# 设置 MySQL 远程认证
sed -i '$a bind-address = 0.0.0.0' /etc/my.cnf

systemctl set-environment MYSQLD_OPTS="--skip-grant-tables"
systemctl restart mysqld.service

mysql --user="root" -e "UPDATE mysql.user SET authentication_string = PASSWORD('vagrant') WHERE User = 'root' AND Host = 'localhost';"
mysql --user="root" -e "FLUSH PRIVILEGES;"

systemctl set-environment MYSQLD_OPTS="--validate-password=OFF"
systemctl restart mysqld.service

mysql --user="root" --password="vagrant" --connect-expired-password -e "SET PASSWORD = PASSWORD('vagrant');"

systemctl set-environment MYSQLD_OPTS=""
systemctl restart mysqld.service

mysql --user="root" --password="vagrant" -e "UNINSTALL PLUGIN validate_password;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO root@'localhost' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "FLUSH PRIVILEGES;"

mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'localhost' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'0.0.0.0' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'vagrant'@'%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "FLUSH PRIVILEGES;"

systemctl restart mysqld.service

# 添加 MySQL 时区支持
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user="root" --password="vagrant" mysql