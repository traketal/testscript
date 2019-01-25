source /etc/functions.sh # load our functions

apt_install lsb-release figlet update-motd \
landscape-common update-notifier-common
cd $HOME/veilpool/install//ubuntu/etc/update-motd.d
sudo rm -r /etc/update-motd.d/
sudo mkdir /etc/update-motd.d/
sudo touch /etc/update-motd.d/00-header ; sudo touch /etc/update-motd.d/10-sysinfo ; sudo touch /etc/update-motd.d/90-footer
sudo chmod +x /etc/update-motd.d/*
sudo cp -r 00-header 10-sysinfo 90-footer /etc/update-motd.d/
cd $HOME/veilpool/install/ubuntu
sudo cp -r nomp /usr/bin/
sudo chmod +x /usr/bin/nomp
echo '
clear
run-parts /etc/update-motd.d/ | sudo tee /etc/motd
' | sudo -E tee /usr/bin/motd >/dev/null 2>&1

sudo chmod +x /usr/bin/motd

cd $HOME/veilpool/install
