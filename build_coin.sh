# set our variables
source /etc/functions.sh
source /etc/veilpool.conf
source $HOME/veilpool/daemon_builder/.my.cnf
cd $HOME/veilpool/daemon_builder

# Select random unused port for coin.conf creation

function EPHYMERAL_PORT(){
    LPORT=32768;
    UPORT=60999;
    while true; do
        MPORT=$[$LPORT + ($RANDOM % $UPORT)];
        (echo "" >/dev/tcp/127.0.0.1/${MPORT}) >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo $MPORT;
            return 0;
        fi
    done
}

clear

echo Download and Build coin from tar...
sudo mkdir $STORAGE_ROOT/daemon_builder/veil

cd $STORAGE_ROOT/daemon_builder/veil
sudo wget https://github.com/Veil-Project/veil/releases/download/v1.0.0.10/veil-1.0.0-x86_64-linux-gnu.tar.gz
sudo tar xvfz veil-1.0.0-x86_64-linux-gnu.tar.gz
cd $STORAGE_ROOT/daemon_builder/veil/veil-1.0.0/

sudo cp $STORAGE_ROOT/daemon_builder/veil/veil-1.0.0/bin/veild /usr/bin
sudo cp $STORAGE_ROOT/daemon_builder/veil/veil-1.0.0/bin/veil-cli /usr/bin


# Make the new wallet folder and autogenerate the coin.conf
if [[ ! -e '$STORAGE_ROOT/wallets' ]]; then
sudo mkdir -p $STORAGE_ROOT/wallets
fi

sudo setfacl -m u:$USER:rwx $STORAGE_ROOT/wallets
mkdir -p $STORAGE_ROOT/wallets/.veil

rpcpassword=$(openssl rand -base64 29 | tr -d "=+/")
rpcport=$(EPHYMERAL_PORT)

echo 'rpcuser=NOMPrpc
rpcpassword='${rpcpassword}'
rpcport='${rpcport}'
rpcthreads=8
rpcallowip=127.0.0.1
# onlynet=ipv4
maxconnections=12
daemon=1
gen=0
' | sudo -E tee $STORAGE_ROOT/wallets/.veil/veil.conf >/dev/null 2>&1

echo "Starting Veil"
/usr/bin/veild -datadir=$STORAGE_ROOT/wallets/.veil -conf=veil.conf -daemon -shrinkdebugfile


# Create easy daemon start file
echo '
veild -datadir=$STORAGE_ROOT/wallets/.veil -conf=veil.conf -daemon -shrinkdebugfile
' | sudo -E tee /usr/bin/veil >/dev/null 2>&1
sudo chmod +x /usr/bin/veil


# If we made it this far everything built fine removing last coin.conf and build directory

sudo rm -r $STORAGE_ROOT/daemon_builder/veil
sudo rm -r $HOME/veilpool/daemon_builder/.my.cnf

echo 'rpcpassword='${rpcpassword}'
rpcport='${rpcport}''| sudo -E tee $HOME/veilpool/daemon_builder/.my.cnf

cd $HOME/veilpool/install
