#!/bin/sh

# run these lines to get this file
# git clone https://github.com/gutmann/SnowMeasureLivox-NCAR.git
# cp SnowMeasureLivox-NCAR/setup_pi.sh ./
# chmod +x setup_pi.sh
# ./setup_pi.sh

sudo apt-get update
sudo apt-get install cmake
# sudo apt-get install git

# To Install a miniconda environment:
# wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-aarch64.sh
# ./Miniconda3-py39_4.12.0-Linux-aarch64.sh

# To get the Livox viewer software
# wget https://terra-1-g.djicdn.com/65c028cd298f4669a7f0e40e50ba1131/Download/update/Livox_Viewer_For_Linux_Ubuntu16.04_x64_0.10.0.tar.gz

# Classic livox SDK
git clone https://github.com/Livox-SDK/Livox-SDK.git
cd Livox-SDK
mkdir -p build
cd build
cmake ..
make
cd ../../

echo "Python version installed:"
python -V
pyver=$(python -V 2>&1 | sed 's/.* \([0-9]\).\([0-9]\).*/\1\2/')

if [ "$pyver" -lt 38 ]; then
    echo "WARNING python version is too low: >3.8 required"
    python -V
    #Version less than 3.8, must upgrade
	echo "Installed python version less than 3.8.0, must upgrade"
	echo "This is going to take a minute, please be patient..."
	sudo apt-get install -y build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev\
	libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev

    python_version="3.8.14"
	wget https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tar.xz
	tar xf Python-${python_version}.tar.xz
	cd Python-${python_version}
	./configure --enable-optimizations --prefix=/usr
	make

	sudo make altinstall
	cd ..
	# sudo rm -r Python-${python_version}
	# rm Python-${python_version}.tar.xz
	. ~/.bashrc

	sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
	echo "If God loves you, you should see Python ${python_version} come up next."
	python -V
fi

# Installs necessary Python libraries
echo "Installing Python packages necessary for SnowMeasureLivox-NCAR..."
pip install numpy=1.22.4
pip install adafruit-circuitpython-gps
pip install crcmod
pip install laspy
pip install tqdm
pip install serial

# sudo pip3 install adafruit-circuitpython-gps
# sudo pip3 install crcmod
# sudo pip3 install laspy
# sudo pip3 install tqdm


# OpenPyLivox
git clone https://github.com/ryan-brazeal-ufl/OpenPyLivox.git
cd OpenPyLivox
sudo python ./setup.py install
cd ../

# Disable serial console and enable access to hardware UART for GPS
# Hard to find documentation on using raspi-config non-interactively
# use argument 0 to enable serial console, 1 to disable, and 3 to disable AND enable hardware UART
echo "Disabling serial console and enabling hardware UART..."
sudo raspi-config nonint do_serial 2

#All done
echo -e "All done. Please test:\n \thardware UART,\n \tpython -c 'from multiprocessing import shared_memory'\n \trun SnowMeasureLivox.py\n to confirm"

# Append to dhcpcd.conf lines to configure static IP address for ethernet interface
# Refer to Livox documentation
sudo echo -e "# Following lines implement static IP configuration for ethernet interface \ninterface eth0 \nstatic ip_address=198.168.1.50 \nstatic netmask=255.255.255.0" >> /etc/dhcpcd.conf
# ifconfig eth0 static 198.168.1.50
# echo "now run raspi-config?"
cd SnowMeasureLivox-NCAR
mkdir build
cp src/* build/
cp config/* build/
cp SnowMeasureLivox.py build/
cd build
ls -lh
echo "run > python ./SnowMeasureLivox.py"
