source /etc/functions.sh
source /etc/veilpool.conf
source $STORAGE_ROOT/nomp/.nomp.conf

echo Installing cron screens to crontab...
(crontab -l 2>/dev/null; echo "@reboot sleep 20 && /home/nomp/nomp/starts/nomp.start.sh") | crontab -
(crontab -l 2>/dev/null; echo "@reboot source /etc/functions.sh") | crontab -
(crontab -l 2>/dev/null; echo "@reboot source /etc/veilpool.conf") | crontab -

echo Creating NOMP startup script...
echo '#!/usr/bin/env bash
source /etc/veilpool.conf
################################################################################
# Author: cryptopool.builders
# Modified for Veil NOMP Private Pools
#
# Program: nomp screen startup script
#
#
################################################################################
cd $STORAGE_ROOT/nomp/site
screen -dmS nomp authbind node init.js
' | sudo -E tee $STORAGE_ROOT/nomp/starts/nomp.start.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/nomp/starts/nomp.start.sh

echo '
source /etc/veilpool.conf
source $STORAGE_ROOT/nomp/.nomp.conf
' | sudo -E tee $STORAGE_ROOT/nomp/.prescreens.start.conf >/dev/null 2>&1

echo "source /etc/veilpool.conf" | hide_output tee -a ~/.bashrc
echo "source $STORAGE_ROOT/nomp/.prescreens.start.conf" | hide_output tee -a ~/.bashrc

sudo rm -r $STORAGE_ROOT/nomp/nomp_setup
