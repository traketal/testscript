#!/usr/bin/env bash


#########################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...then moded for Veil
# This script is intended to be run like this:
#
#   curl https://raw.githubusercontent.com/traketal/testscript/master/bootstrap.sh | bash
#
#########################################################



	echo Downloading Veil NOMP Pool Installer. . .
	git clone https://github.com/traketal/testscript \
		"$HOME"/veilpool/install \
		< /dev/null 2> /dev/null

	echo


# Set permission and change directory to it.
cd $HOME/veilpool/install

# Start setup script.
bash $HOME/veilpool/install/start.sh
