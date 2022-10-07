#!/bin/bash

# See directions from https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-routed-wireless-access-point
# Install AP and Management Software
sudo apt install hostapd
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo apt install dnsmasq
sudo DEBIAN_FRONTEND=noninteractive
sudo apt install -y netfilter-persistent iptables-persistent

# Define the Wireless Interface IP Configuration
cp /etc/dhcpcd.conf dhcpcd.conf
echo -e "interface wlan0 \n    static ip_address=192.168.4.1/24 \n    nohook wpa_supplicant" >> dhcpcd.conf
sudo cp dhcpcd.conf /etc/dhcpcd.conf

# Configure the DHCP and DNS services for the wireless network
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
# cp /etc/dnsmasq.conf.orig dnsmasq.conf
echo "interface=wlan0 # Listening interface" >dnsmasq.conf
echo "dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h" >>dnsmasq.conf
echo "                # Pool of IP addresses served via DHCP" >>dnsmasq.conf
echo "domain=wlan     # Local wireless DNS domain" >>dnsmasq.conf
echo "address=/${HOSTNAME}.wlan/192.168.4.1" >>dnsmasq.conf
echo "                # Alias for this router" >>dnsmasq.conf
sudo cp dnsmasq.conf /etc/dnsmasq.conf

# Ensure Wireless Operation
sudo rfkill unblock wlan

cp /etc/hostapd/hostapd.conf hostapd.conf
echo "country_code=US" >>hostapd.conf
echo "interface=wlan0" >>hostapd.conf
echo "ssid=livoxnet-"${HOSTNAME:8:2} >>hostapd.conf
echo "hw_mode=g" >>hostapd.conf
# THIS IS OK FOR 2.4GHZ
# echo "channel="${HOSTNAME:9:1} >>hostapd.conf
echo "channel=7" >>hostapd.conf
# THIS IS OK FOR 5GHZ in the US  https://en.wikipedia.org/wiki/List_of_WLAN_channels#United_States
# echo "channel=149" >>hostapd.conf

# To hide SSID set to 1
echo "ignore_broadcast_ssid=0" >>hostapd.conf

# MAC address Access Control List
echo "macaddr_acl=0" >>hostapd.conf

# To Enable WPA2 encryption
echo "auth_algs=1" >>hostapd.conf
echo "wpa=2" >>hostapd.conf
echo "wpa_passphrase=livoxPiWiFi" >>hostapd.conf
echo "wpa_key_mgmt=WPA-PSK" >>hostapd.conf
echo "wpa_pairwise=TKIP" >>hostapd.conf
echo "rsn_pairwise=CCMP" >>hostapd.conf
sudo cp hostapd.conf /etc/hostapd/hostapd.conf

echo "WAP setup reboot now to enable"
