source /etc/functions.sh
cd ~/veilpool/install
clear
message_box "Veil NOMP Setup Installer" \
"Naughty, naughty! You are trying to install this as the root user!
\n\nRunning any application as root is a serious security risk.
\n\nTherefore we make you create a user account :)"

if [ -z "${nompadmin}" ]; then
DEFAULT_nompadmin=nompadmin
input_box "New Account Name" \
"Please enter your desired user name.
\n\nUser Name:" \
${DEFAULT_nompadmin} \
nompadmin

if [ -z "${nompadmin}" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "${RootPassword}" ]; then
DEFAULT_RootPassword=$(openssl rand -base64 8 | tr -d "=+/")
input_box "User Password" \
"Enter your new user password or use this randomly system generated one.
\n\nUnfortunatley dialog doesnt let you copy. So you have to write it down.
\n\nUser password:" \
${DEFAULT_RootPassword} \
RootPassword

if [ -z "${RootPassword}" ]; then
# user hit ESC/cancel
exit
fi
fi

clear

dialog --title "Verify Your Responses" \
--yesno "Please verify your answers before you continue:

New User Name : ${nompadmin}
New User Pass : ${RootPassword}" 8 60

# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
# 255 means user hit [Esc] key.
response=$?
case $response in

0)
clear
echo Adding new user and password...

sudo adduser ${nompadmin} --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo -e "${RootPassword}\n${RootPassword}" | passwd ${nompadmin}
sudo usermod -aG sudo ${nompadmin}

echo '# nomp
# It needs passwordless sudo functionality.
'""''"${nompadmin}"''""' ALL=(ALL) NOPASSWD:ALL
' | sudo -E tee /etc/sudoers.d/${nompadmin} >/dev/null 2>&1

echo '
cd ~/veilpool/install
bash start.sh
' | sudo -E tee /usr/bin/veilpool >/dev/null 2>&1
sudo chmod +x /usr/bin/veilpool

sudo cp -r ~/veilpool /home/${nompadmin}/
cd ~
sudo rm -r veilpool
sudo setfacl -m u:${nompadmin}:rwx /home/${nompadmin}/veilpool

clear
echo "New User is installed..."
echo "Please reboot system and log in as the new user and type veilpool to continue setup..."
exit 0;;

1)

clear
bash $(basename $0) && exit;;

255)

;;
esac
