#!/usr/bin/env bash

source /etc/functions.sh
source /etc/veilpool.conf

# Set STORAGE_USER and STORAGE_ROOT to default values (crypto-data and /home/crypto-data), unless
# we've already got those values from a previous run.
if [ -z "$STORAGE_USER" ]; then
STORAGE_USER=$([[ -z "$DEFAULT_STORAGE_USER" ]] && echo "pool-data" || echo "$DEFAULT_STORAGE_USER")
fi
if [ -z "$STORAGE_ROOT" ]; then
STORAGE_ROOT=$([[ -z "$DEFAULT_STORAGE_ROOT" ]] && echo "/home/$STORAGE_USER" || echo "$DEFAULT_STORAGE_ROOT")
fi

# Create the temporary installation directory if it doesn't already exist.
echo Creating the temporary NOMP installation folder...
if [ ! -d $STORAGE_ROOT/nomp/nomp_setup ]; then
sudo mkdir -p $STORAGE_ROOT/nomp
sudo mkdir -p $STORAGE_ROOT/nomp/nomp_setup
sudo mkdir -p $STORAGE_ROOT/nomp/nomp_setup/tmp
sudo mkdir -p $STORAGE_ROOT/nomp/site
sudo mkdir -p $STORAGE_ROOT/nomp/starts
sudo mkdir -p $STORAGE_ROOT/wallets
sudo mkdir -p $HOME/veilpool/daemon_builder
sudo mkdir -p $STORAGE_ROOT/daemon_builder
fi
sudo setfacl -m u:$USER:rwx $STORAGE_ROOT/nomp
sudo setfacl -m u:$USER:rwx $STORAGE_ROOT/nomp/site
sudo setfacl -m u:$USER:rwx $STORAGE_ROOT/wallets
sudo setfacl -m u:$USER:rwx $STORAGE_ROOT/nomp/nomp_setup/tmp

# Start the installation.
source questions.sh
source system.sh
source db.sh
source web.sh
#source daemon.sh
source build_coin.sh
source nomp.sh
source motd.sh
source server_harden.sh
source server_cleanup.sh

clear
echo Installation of your NOMP single server is now completed.
echo You *MUST* reboot the machine to finalize the machine updates and folder permissions! NOMP will not function until a reboot is performed!
echo
echo
echo By default all stratum ports are blocked by the firewall. To allow a port through, from the command prompt type sudo ufw allow port number.
