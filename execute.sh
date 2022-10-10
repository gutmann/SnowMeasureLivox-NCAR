#!/bin/bash

# ensure lidar mode is set correctly
cd /home/pi/SnowMeasureLivox-NCAR/build/
python ./SnowMeasureLivox.py

# collect data
data_path=`ls -1 /media/pi/ | head -1`
cd /media/pi/${data_path}

date >> ${HOSTNAME}.txt

/home/pi/lidar_lvx_sample

# compress data to save disk space
for i in *.lvx; do
    gzip $i
done
