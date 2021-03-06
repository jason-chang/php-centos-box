#!/usr/bin/env bash

# 安装 Supervisor
yum install -y python python-devel python-pip supervisor
systemctl enable supervisord.service
systemctl start supervisord.service

# 安装 Node
yum install -y nodejs  --enablerepo=nodesource
/usr/bin/npm install -g gulp
/usr/bin/npm install -g bower
/usr/bin/npm install -g webpack

# 安装 SQLite
yum install -y sqlite sqlite-devel

# 配置 Redis
yum install -y redis
systemctl enable redis.service
systemctl start redis.service

# 配置 memcached
yum install -y memcached
systemctl enable memcached.service
systemctl start memcached.service

# 配置 Beanstalkd
yum install -y beanstalkd
systemctl enable beanstalkd.service
systemctl start beanstalkd.service

# Git
yum install -y git

# Fuck gfw 希望成功 安装 Composer
curl -sS http://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# 添加 Composer 程序目录到全局变量
sed -i '/PATH=/{s/$/\:\$HOME\/\.config\/composer\/vendor\/bin/}' /home/vagrant/.bash_profile