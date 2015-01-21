# NGINX-SSL

A simple script to provision NGINX with a self-signed SSL certificate on a Ubuntu 14.04 box.

```
Basic usage: sudo bash bootstrap.sh

Command line switches are optional. The following switches are recognized.
-d          --Sets whether SSLMate is used. Default is off.
-p [PORT]   --Sets the value for port used for the application. Default is 5000.
-s [SERVER] --Sets the value for the server name. Default is the IP address.
-h  --Displays this help message. No further functions are performed.

Example: sudo bash bootstrap.sh -d -p 4567 -s test.example.com
```

To execute:
```
# wget https://esq.io/nginx-ssl.tar.gz
# tar -xfz nginx-ssl.tar.gz
git clone https://github.com/vzvenyach/nginx-ssl.git
cd nginx-ssl
sudo ./bootstrap.sh
sudo service nginx restart
```