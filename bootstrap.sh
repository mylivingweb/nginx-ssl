#!/bin/bash
# This is a script to automatically load the nginx configuration

##
# COMMAND LINE ARGUMENTS
#

NORM=`tput sgr0`
BOLD=`tput bold`
NGINXREPO=/etc/yum.repos.d/nginx.repo

# Will only work if you only have 1 public interface, please alter if you are using more than 1 public interface
IP_ADDRESS="$(hostname -I)"
HOSTNAME="$(hostname)"
# Set Defaults
OPT_A="443"
SERVER_NAME=$IP_ADDRESS
OPT_SSL="False"
HOSTNAMESTUFF()
{
    echo -e "\033[36m Your hostname is $HOSTNAME, moving on...\e[0m"

}
NGINXREPO()
{
	if [ -f $NGINXREPO ]
	then
		echo -e "\033[36m Nginx Repository is already installed, moving on...\e[0m"
	else
		# Add Nginx Repository
		echo -e "\033[36mAdding Nginx Repository, Please Wait...\e[0m"
		rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm &>> $INSTALLLOG || OwnError "Unable To Add Nginx Repository"

	fi
}
INSTALLNGINX()
{
	# Install Nginx Package
	echo -e "\033[34mInstalling Nginx, Please Wait...\e[0m"
	yum install nginx -y || OwnError "Unable To Install Nginx"
}
ENABLENGINX()
{
    echo -e "\033[36mEnabling NGINX on boot. Please Wait...\e[0m"
    sudo systemctl enable nginx
    echo -e "\033[36mRestarting NGINX. Please Wait...\e[0m"
    sudo systemctl restart nginx

}
FANCYNGINX()
{
    echo -e "\033[36mCopying files. Please Wait...\e[0m"
    cp local.conf /etc/nginx/conf.d/local.conf
    echo -e "\033[36mMaking dir. Please Wait...\e[0m"
    mkdir -p /etc/nginx/ssl
    echo -e "\033[36mCopying files. Please Wait...\e[0m"
    cp ssl.rules /etc/nginx/ssl/ssl.rules
    echo -e "\033[36mCopying files. Please Wait...\e[0m"
    cp nginx.conf /etc/nginx/nginx.conf
}
FWUPDATE()
{
    #UPDATE FIREWALLD FOR SERVER
    echo -e "\033[36mUpdating firewalld. Please Wait...\e[0m"
    sudo firewall-cmd --permanent --zone=public --add-service=http
    sudo firewall-cmd --permanent --zone=public --add-service=https
    sudo firewall-cmd --reload

}
SSLMATE()
{
    echo -e "\033[36mGetting sslmate stuff. Please Wait...\e[0m"
    wget -P /etc/yum.repos.d https://sslmate.com/yum/centos/SSLMate.repo
    wget -P /etc/pki/rpm-gpg https://sslmate.com/yum/centos/RPM-GPG-KEY-SSLMate
    #INSTALL SSLMATE
    echo -e "\033[36mInstalling sslmate stuff. Please Wait...\e[0m"
    yum install -y sslmate
    echo -e "\033[36mBuying sslmate stuff. YOU NEED AN EXISTING SSLMATE ACCOUNT - https://sslmate.com, waiting...\e[0m"
    sslmate buy $SERVER_NAME
    echo -e "\033[36mLinking sslmate things and stuff. Please Wait...\e[0m"
    ln -s /etc/sslmate/$SERVER_NAME.key /etc/nginx/ssl/keys/private.key
    ln -s /etc/sslmate/$SERVER_NAME.chained.crt /etc/nginx/ssl/keys/server.crt
    openssl dhparam -outform pem -out /etc/nginx/ssl/dhparam2048.pem 2048

}
CLEANUP()
{
    echo -e "\033[36mReplacing things and stuff. Please Wait...\e[0m"
    sed -i "s/SERVER_NAME/$SERVER_NAME/" /etc/nginx/conf.d/local.conf
    sed -i "s/PORT_NUMBER/$OPT_A/" /etc/nginx/conf.d/local.conf
    # sed -i "s/SSL_ROOT/$SSL_ROOT" /etc/nginx/ssl/ssl.rules
    sudo systemctl restart nginx

}

HOSTNAMESTUFF
sleep 1
NGINXREPO
sleep 1
INSTALLNGINX
sleep 1
ENABLENGINX
sleep 1
FANCYNGINX
sleep 1
FWUPDATE
sleep 1
SSLMATE
sleep 1
CLEANUP

echo -e "\033[36mAll done with things and stuff.\e[0m"