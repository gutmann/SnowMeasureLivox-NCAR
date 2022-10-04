#!/bin/sh

# run these lines to get this file
# git clone https://github.com/gutmann/SnowMeasureLivox-NCAR.git
# cp SnowMeasureLivox-NCAR/setup_pi.sh ./
# chmod +x setup_pi.sh
# ./setup_pi.sh

sudo apt-get install cmake

# To Install a miniconda environment:
# wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-aarch64.sh
# ./Miniconda3-py39_4.12.0-Linux-aarch64.sh

# To get the Livox viewer software
# wget https://terra-1-g.djicdn.com/65c028cd298f4669a7f0e40e50ba1131/Download/update/Livox_Viewer_For_Linux_Ubuntu16.04_x64_0.10.0.tar.gz

# Classic livox SDK
git clone https://github.com/Livox-SDK/Livox-SDK.git
cd Livox-SDK
mkdir -P build
cd build
cmake ..
make


# Installs necessary Python libraries
echo "Installing Python packages necessary for SnowMeasureLivox-NCAR..."
sudo pip3 install adafruit-circuitpython-gps
sudo pip3 install crcmod
sudo pip3 install laspy
sudo pip3 install tqdm

# OpenPyLivox
git clone https://github.com/ryan-brazeal-ufl/OpenPyLivox.git


# Disable serial console and enable access to hardware UART for GPS
# Hard to find documentation on using raspi-config non-interactively
# use argument 0 to enable serial console, 1 to disable, and 3 to disable AND enable hardware UART
echo "Disabling serial console and enabling hardware UART..."
sudo raspi-config nonint do_serial 2

#All done
echo -e "All done. Please test:\n \thardware UART,\n \tpython from multiprocessing import shared_memory\n \trun SnowMeasureLivox.py\n to confirm"

# Append to dhcpcd.conf lines to configure static IP address for ethernet interface
# Refer to Livox documentation
sudo echo -e "# Following lines implement static IP configuration for ethernet interface \ninterface eth0 \nstatic ip_address=198.127.1.27 \nstatic netmask=255.255.255.0" >> /etc/dhcpcd.conf
