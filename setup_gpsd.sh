#!/bin/sh

# directions from https://n4bfr.com/2021/11/raspberry-pi-gps-time-server-with-bullseye/
sudo apt-get install -y gpsd gpsd-clients gpsd-tools

# sudo cat /dev/ttyS0

sudo killall gpsd
sudo gpsd /dev/ttyS0 -n -F /var/run/gpsd.sock

# gpsmon

# sudo nano /etc/default/gpsd
cat <<EOF >gpsd.conf
#Updated for GPS Pi Clock

START_DAEMON="true"

# Devices gpsd should collect to at boot time.

GPSD_SOCKET="/var/run/gpsd.sock"

# They need to be read/writeable, either by user gpsd or the group dialout.
DEVICES="/dev/ttyAMA0"

# Other options you want to pass to gpsd
GPSD_OPTIONS="-n"
GPSD_SOCKET="/var/run/gpsd.sock"

# Automatically hot add/remove USB GPS devices via gpsdctl
USBAUTO="false"
EOF
sudo cp gpsd.conf /etc/default/gpsd

sudo systemctl stop gpsd.socket
sudo systemctl disable gpsd.socket
sudo ln -s /lib/systemd/system/gpsd.service /etc/systemd/system/multi-user.target.wants/

sudo apt-get install -y ntp

sudo systemctl stop systemd-timesyncd
sudo systemctl disable systemd-timesyncd
sudo service ntp stop
sudo service ntp startntp q -

# test that it is using network time servers
# ntpq -p -c rl

cp /etc/ntp.conf ./ntp.conf
cat <<EOF >>ntp.conf
# Kernel-mode PPS reference-clock for the precise seconds
# server 127.127.22.0 minpoll 4 maxpoll 4
# fudge 127.127.22.0 refid PPS

# Coarse time reference-clock - nearest second
server 127.127.28.0 minpoll 4 maxpoll 4 iburst prefer
fudge 127.127.28.0 time1 +0.105 flag1 1 refid GPS
EOF
sudo cp ./ntp.conf /etc/ntp.conf

sudo service ntp restart

# test that it is now using GPS server
# ntpq -p -c rl
