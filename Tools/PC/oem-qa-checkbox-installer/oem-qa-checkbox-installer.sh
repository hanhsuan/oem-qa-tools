#!/bin/bash

# make all files in bin/ executable
chmod +x ./bin/*

# Get CID, secure ID, SKU info from C3
./bin/get-id-info.py

# Set up environment
./bin/env-setup.sh

# Install checkbox
./bin/boxer.py

#Install other essential packages
./bin/install-packages.sh

# Get hardware info
./bin/get-hw-info.sh

# Print out hardware info
cat ./hardware_info.txt

# Remove boxer.conf
rm ./conf/setting.conf

# Copy plainbox.conf to the following path
printf "\nCopying plainbox.conf to ~/.conf and /etc/xdg ...\n"
sudo cp ./conf/plainbox.conf "$HOME"/.config/
sudo cp ./conf/plainbox.conf /etc/xdg/

# check MAC of net devices aren't in black list
./bin/check-net-mac.sh -f ./conf/black_MAC_list.conf

while true; do
    read -r -p "Press 'r' to reboot or 'e' to exit: " rse
    case $rse in
        [Rr]* ) reboot;;
        [Ee]* ) exit;;
        * ) echo "Please answer 'r' or 'e'.";;
    esac
done
