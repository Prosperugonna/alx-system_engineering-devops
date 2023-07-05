#!/usr/bin/env bash
# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Define Nginx server block
file { '/etc/nginx/sites-available/default':
  ensure => present,
  content => "
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    add_header X-Served-By \$hostname;
}
",
}

# Enable the Nginx server block
file { '/etc/nginx/sites-enabled/default':
  ensure => 'link',
  target => '/etc/nginx/sites-available/default',
  require => File['/etc/nginx/sites-available/default'],
  notify => Service['nginx'],
}

# Start and enable Nginx service
service { 'nginx':
  ensure => 'running',
  enable => true,
}
