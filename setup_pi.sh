#!/bin/sh

sudo apt-get install cmake
git clone https://github.com/gutmann/SnowMeasureLivox-NCAR.git

# wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-aarch64.sh
# ./Miniconda3-py39_4.12.0-Linux-aarch64.sh

# wget https://terra-1-g.djicdn.com/65c028cd298f4669a7f0e40e50ba1131/Download/update/Livox_Viewer_For_Linux_Ubuntu16.04_x64_0.10.0.tar.gz

git clone https://github.com/ryan-brazeal-ufl/OpenPyLivox.git

git clone https://github.com/Livox-SDK/Livox-SDK.git
cd Livox-SDK
mkdir -P build
cd build
cmake ..
make
