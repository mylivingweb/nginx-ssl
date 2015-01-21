#!/bin/bash
# This is a script to automatically load the nginx configuration

##
# COMMAND LINE ARGUMENTS
#

NORM=`tput sgr0`
BOLD=`tput bold`

function HELP {
  echo -e \\n"Help documentation for NGINX-SSL"\\n
  echo -e "Basic usage: sudo bash bootstrap.sh"\\n
  echo "Command line switches are optional. The following switches are recognized."
  echo "-d          --Sets whether SSLMate is used. Default is ${BOLD}off${NORM}."
  echo "-p [PORT]   --Sets the value for port used for the application. Default is ${BOLD}5000${NORM}."
  echo "-s [SERVER] --Sets the value for the server name. Default is ${BOLD}the IP address${NORM}."
  echo -e "-h  --Displays this help message. No further functions are performed."\\n
  echo -e "Example: sudo bash bootstrap.sh -d -p 4567 -s test.example.com"\\n
  exit 1
}

# NOTE: THIS SEEMS TO WORK ONLY ON UBUNTU
IP_ADDRESS="$(ifconfig | egrep -o -m 1 'inet addr:[0-9|.]+' | egrep -o '[0-9|.]+')"

# Set Defaults
OPT_A="5000"
SERVER_NAME=$IP_ADDRESS
OPT_SSL="False"

# Get the command arguments
while getopts :p:s:dh FLAG; do
  case $FLAG in
    d)  # is d set?
      OPT_SSL="True"
      ;;
    p)  #set option "a"
      OPT_A=$OPTARG
      ;;
    s)  #set option "b"
      SERVER_NAME=$OPTARG
      ;;
    h)  #show help
      HELP
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      HELP
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

add-apt-repository -y ppa:nginx/stable
apt-get update
apt-get -y install nginx
cp local.conf /etc/nginx/conf.d/local.conf
mkdir -p /etc/nginx/ssl
cp ssl.rules /etc/nginx/ssl/ssl.rules
cp nginx.conf /etc/nginx/nginx.conf

# Generate the Keys
if [ $OPT_SSL = "False" ]
then
    mkdir -p /etc/nginx/ssl/keys
    openssl genpkey -algorithm RSA -out /etc/nginx/ssl/keys/private.key -pkeyopt rsa_keygen_bits:2048
    openssl rsa -in /etc/nginx/ssl/keys/private.key -out /etc/nginx/ssl/keys/private-decrypted.key
    openssl req -new -sha256 -key /etc/nginx/ssl/keys/private-decrypted.key -subj "/CN=$SERVER_NAME" -out /etc/nginx/ssl/keys/$SERVER_NAME.csr
    openssl x509 -req -days 365 -in /etc/nginx/ssl/keys/$SERVER_NAME.csr -signkey /etc/nginx/ssl/keys/private.key -out /etc/nginx/ssl/keys/server.crt
    rm /etc/nginx/ssl/keys/private-decrypted.key
    rm /etc/nginx/ssl/keys/$SERVER_NAME.csr
else
    wget -P /etc/apt/sources.list.d https://sslmate.com/apt/ubuntu1404/sslmate.list
    wget -P /etc/apt/trusted.gpg.d https://sslmate.com/apt/ubuntu1404/sslmate.gpg
    apt-get update
    apt-get install -y sslmate
    sslmate buy $SERVER_NAME
    ln -s /etc/sslmate/$SERVER_NAME.key /etc/nginx/ssl/keys/private.key
    ln -s /etc/sslmate/$SERVER_NAME.chained.crt /etc/nginx/ssl/keys/server.crt
fi

openssl dhparam -outform pem -out /etc/nginx/ssl/dhparam2048.pem 2048

sed -i "s/SERVER_NAME/$SERVER_NAME/" /etc/nginx/conf.d/local.conf
sed -i "s/PORT_NUMBER/$OPT_A/" /etc/nginx/conf.d/local.conf
# sed -i "s/SSL_ROOT/$SSL_ROOT" /etc/nginx/ssl/ssl.rules