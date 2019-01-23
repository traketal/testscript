source /etc/functions.sh
source /etc/veilpool.conf
source $STORAGE_ROOT/nomp/.nomp.conf
source $HOME/veilpool/daemon_builder/.my.cnf

# Create function for random unused port
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

echo "Making the NOMPness Monster"

cd $STORAGE_ROOT/nomp/site/

# NPM install and update, user can ignore errors
npm install
npm i npm@latest -g

# SED config file
sudo cp -r $HOME/veilpool/config.json $STORAGE_ROOT/nomp/site/config.json
sudo sed -i 's/PUBIP/'$PUBLIC_IP'/g' config.json
sudo sed -i 's/FQDN/'$StratumURL'/g' config.json
sudo sed -i 's/PASSWORD/'$AdminPass'/g' config.json

# Create the coin json file
cd $STORAGE_ROOT/nomp/site/pool_configs
sudo cp -r $HOME/veilpool/installbase_samp.json.x $STORAGE_ROOT/nomp/site/pool_configs/veil.json

# Generate our random ports
randportlow=$(EPHYMERAL_PORT)
randportvar=$(EPHYMERAL_PORT)
randporthigh=$(EPHYMERAL_PORT)

#Generate new wallet address
/usr/bin/veil-cli stop
sleep 2
seed="$(veild -generateseed=1)"
sleep 2
/usr/bin/veil-cli stop
sleep 2
wallet="$(veil-cli -datadir=$STORAGE_ROOT/wallets/.veil -conf=veil.conf getnewbasecoinaddress)"


# SED the pool config coin file
sudo sed -i 's/wallet/'$wallet'/g' veil.json
sudo sed -i 's/daemonport/'$rpcport'/g' veil.json
sudo sed -i 's/rpcuser/NOMPrpc/g' veil.json
sudo sed -i 's/rpcpass/'$rpcpassword'/g' veil.json
sudo sed -i 's/randportlow/'$randportlow'/g' veil.json
sudo sed -i 's/randportvar/'$randportvar'/g' veil.json
sudo sed -i 's/randporthigh/'$randporthigh'/g' veil.json

# need to code for the generateseed to be stored here. 

# Allow user account to bind to port 80 and 443 with out sudo privs
apt_install authbind
sudo touch /etc/authbind/byport/80
sudo touch /etc/authbind/byport/443
sudo chmod 777 /etc/authbind/byport/80
sudo chmod 777 /etc/authbind/byport/443

# Update site with users information
# cd $STORAGE_ROOT/nomp/site/website/
# sudo sed -i 's/sed_domain/'$DomainName'/g' index.html
# cd $STORAGE_ROOT/nomp/site/website/pages/
# sudo sed -i 's/sed_domain/'$DomainName'/g' dashboard.html
# sudo sed -i 's/sed_stratum/'$StratumURL'/g' getting_started.html
# sudo sed -i 's/sed_domain/'$DomainName'/g' home.html
# sudo sed -i 's/sed_stratum/'$StratumURL'/g' pools.html

cd $HOME/veilpool/install
