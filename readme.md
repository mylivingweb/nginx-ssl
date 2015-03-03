# NGINX-SSL - CentOS 7

A simple script to provision NGINX with a self-signed SSL certificate on a Centos 7 box.

```
checks if NGINX is installed, if not, then installs it.

simplied this a bit, pulls hostname of the box, get sslmate certs copies files to nginx dir

pretty straight forward stuff

```

To execute:
```
git clone https://github.com/vzvenyach/nginx-ssl.git
cd nginx-ssl
sudo ./bootstrap.sh

```

Todo:
Integrate with cleaned up easy engine fork to deploy wordpress, mysql, mariadb, and ssl