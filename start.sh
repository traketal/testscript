#!/usr/bin/env bash

cd $HOME/veilpool/install

source functions.sh # load our functions
# copy functions to /etc
sudo cp -r functions.sh /etc/

#check for user
echo Installing needed packages for setup to continue...

sudo apt-get -q -q update
apt_get_quiet install dialog python3 python3-pip acl nano git || exit 1

# Are we running as root?
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root. Please re-run like this:"
	echo
	echo "bash $0"
	echo
  else
  source first_user.sh
	exit
fi

# Ask the user the intial questions
source pre_setup.sh

# Create the STORAGE_USER and STORAGE_ROOT directory if they don't already exist.
if ! id -u $STORAGE_USER >/dev/null 2>&1; then
sudo useradd -m $STORAGE_USER
fi
if [ ! -d $STORAGE_ROOT ]; then
sudo mkdir -p $STORAGE_ROOT
fi

# Save the global options in /etc/veilpool.conf so that standalone
# tools know where to look for data.
echo 'STORAGE_USER='"${STORAGE_USER}"'
STORAGE_ROOT='"${STORAGE_ROOT}"'
PUBLIC_IP='"${PUBLIC_IP}"'
PUBLIC_IPV6='"${PUBLIC_IPV6}"'
PRIVATE_IP='"${PRIVATE_IP}"'' | sudo -E tee /etc/veilpool.conf >/dev/null 2>&1

# Start service configuration.
source menu.sh

# Give fail2ban another restart. The log files may not all have been present when
# fail2ban was first configured, but they should exist now.
restart_service fail2ban

# Done.
echo
echo "-----------------------------------------------"
echo
echo Thank you for using the Veil Pool Setup Installer!
echo
echo To run this installer anytime simply type, veilpool!
cd ~
