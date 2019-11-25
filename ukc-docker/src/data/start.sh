#!/bin/bash
set -e

ep() { 
  if [ -e "/ukc-installed" ]; then
    echo "Starting UKC entry point"
    echo "Waiting for $1..."
    until ping -c1 $1 &>/dev/null; do :; done
    echo "$1 is up"
    start
  else
    echo "Setting up UKC entry point before first start"
    # install
    echo "Waiting for $1..."
    until ping -c1 $1 &>/dev/null; do :; done
    echo "$1 is up"
    /opt/ekm/bin/ekm_boot_ep.sh -s $HOSTNAME -p $1 -x $2 -f -w Password1!
    start
    echo "Checking UKC system..."
    until ucl server test &>/dev/null; do :; done
    echo "UKC system is installed"

    post_install
    
    echo "UKC system is ready"
    touch /ukc-installed
  fi
}

post_install() {
  echo "Executing post install commands"
  if [ "$UKC_NOCERT" == "true" ]
  then
    ucl system-settings set -k no-cert -v 1 -w Password1!
  fi
  
  if [ ! -z "$UKC_PARTITION" ] && [ ! -z "$UKC_PASSWORD" ]
  then
    echo "Creating partition: $UKC_PARTITION"
    ucl partition create -p $UKC_PARTITION -w Password1! -s $UKC_PASSWORD
    
    # echo "Changing partition 'so' password"
    # ucl user change-pwd -p $UKC_PARTITION -w Password1! -d $UKC_PASSWORD
  fi

  if [ ! -z "$UKC_PARTITION" ] && [ ! -z "$UKC_PARTITION_USER_PASSWORD" ]
  then  
    echo "Changing '$UKC_PARTITION' partition 'user' password"
    ucl user change-pwd --user user -p $UKC_PARTITION -d $UKC_PARTITION_USER_PASSWORD
  fi

  if [ ! -z "$UKC_PASSWORD" ]
  then
    echo "Changing 'root' partition 'so' password"
    ucl user change-pwd -p root -w Password1! -d $UKC_PASSWORD
  fi

  if [ ! -z "$UKC_CERTIFICATE_HOST_NAME" ]
  then
    echo "Adding additional hostnames and IP addresses: $UKC_CERTIFICATE_HOST_NAME" 
    /opt/ekm/bin/ekm_renew_server_certificate.sh --name $UKC_CERTIFICATE_HOST_NAME
  fi
  
}


partner() {
  if [ -e "/ukc-installed" ]; then
    echo "Starting UKC partner"
    echo "Waiting for $1..."
    until ping -c1 $1 &>/dev/null; do :; done
    echo "$1 is up"
    start
  else
    echo "Setting up UKC partner before first start"
    # install
    echo "Waiting for $1..."
    until ping -c1 $1 &>/dev/null; do :; done
    echo "$1 is up"
    /opt/ekm/bin/ekm_boot_partner.sh -s $HOSTNAME -p $1 -x $2 -f
    start

    echo "UKC partner is ready"
    touch /ukc-installed
  fi
}

aux() {
  if [ -e "/ukc-installed" ]; then
    echo "Starting UKC AUX"
    start
  else
    echo "Setting up UKC AUX before first start"
    # install
    /opt/ekm/bin/ekm_boot_auxiliary.sh -s $HOSTNAME -e $1 -p $2 -f
    start

    echo "UKC AUX is ready"
    touch /ukc-installed
  fi
}

start() {
  service ekm start
}


case "$1" in
  ep)
    ep $2 $3
    tail -f /dev/null #keep container running
  ;;
  partner)
    partner $2 $3
    tail -f /dev/null #keep container running
  ;;
  aux)
    aux $2 $3
    tail -f /dev/null #keep container running
  ;;   
esac