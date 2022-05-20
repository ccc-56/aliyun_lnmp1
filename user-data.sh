#!/bin/bash
apt-get -y  update 
apt-get install -y php7.4-fpm php7.4-mysql nginx

cat <<'EOF' > /etc/nginx/sites-available/default
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;

	index index.html index.htm index.nginx-debian.html;

	server_name _;

	location / {
		try_files $uri $uri/ =404;
	}
        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        location ~ \.php$ {
          try_files $uri =404;
          fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
          fastcgi_pass unix:/run/php/php7.4-fpm.sock;
          fastcgi_index index.php;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          include fastcgi_params;
        }
}
EOF

systemctl enable php7.4-fpm && service php7.4-fpm restart
systemctl enable nginx && service nginx.service restart

cd /var/www/html
cat <<'EOF1' > a1.php
<?php
  phpinfo( );
?>
EOF1

cat <<'EOF1' > a1.php
<?php
  echo 1+3;
?>
EOF1


