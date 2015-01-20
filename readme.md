# NGINX-SSL

A simple script to provision NGINX with a self-signed SSL certificate on a Ubuntu 14.04 box.

To execute:
```
# wget https://esq.io/nginx-ssl.tar.gz
# tar -xfz nginx-ssl.tar.gz
git clone https://github.com/vzvenyach/nginx-ssl.git
cd nginx-ssl
sudo ./bootstrap.sh
sudo service nginx restart
```

Note, this expects a server running on port 5000. To change that (until I update the configuration options), go ahead and edit `/etc/nginx/conf.d/local.conf` to put it at the port you want to run your site on.