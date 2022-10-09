#!/bin/bash

# ensure lidar mode is set correctly
cd /home/pi/SnowMeasureLivox-NCAR/build/
python ./SnowMeasureLivox.py

# collect data
data_path=`ls -1 -a /media/pi/ | head -1`
cd $data_path

date >> ${HOSTNAME}.txt

# compress data to save disk space
for i in *.lvx; do
    gzip $i
done
