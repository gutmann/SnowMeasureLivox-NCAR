#!/bin/bash

# ensure lidar mode is set correctly
cd /home/pi/SnowMeasureLivox-NCAR/build/
python ./SnowMeasureLivox.py

# collect data
data_path=`ls -1 /media/pi/ | head -1`
cd /media/pi/${data_path}

# on some setups, accessing the livox too quickly after the python code disconnects fails so sleep for 2 seconds first
sleep 2

date >> ${HOSTNAME}-pre.txt
/home/pi/lidar_lvx_sample
date >> ${HOSTNAME}-post.txt

# compress data to save disk space
for i in *.lvx; do
    gzip $i
done
