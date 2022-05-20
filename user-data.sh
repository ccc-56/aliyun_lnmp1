#!/bin/bash
apt-get -y  update 
apt-get install -y php7.4-fpm php7.4-mysql nginx
systemctl enable php7.4-fpm
systemctl enable nginx

cd /var/www/html
curl https://n.sinaimg.cn/finance/crawl/94/w550h344/20220520/c937-5c95767c574c65fe4196d83eb0b4a7e5.png -o a-sin.png
