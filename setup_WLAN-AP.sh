#!/bin/sh
# See directions from https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-routed-wireless-access-point
# Install AP and Management Software
sudo apt install hostapd
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo apt install dnsmasq
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent

# Define the Wireless Interface IP Configuration
sudo echo -e"interface wlan0\n    static ip_address=192.168.4.1/24\n    nohook wpa_supplicant" >> /etc/dhcpcd.conf

# Configure the DHCP and DNS services for the wireless network
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo echo "interface=wlan0 # Listening interface" >>/etc/dnsmasq.conf
sudo echo "dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h" >>/etc/dnsmasq.conf
sudo echo "                # Pool of IP addresses served via DHCP" >>/etc/dnsmasq.conf
sudo echo "domain=wlan     # Local wireless DNS domain" >>/etc/dnsmasq.conf
sudo echo "address=/${HOSTNAME}.wlan/192.168.4.1" >>/etc/dnsmasq.conf
sudo echo "                # Alias for this router" >>/etc/dnsmasq.conf

# Ensure Wireless Operation
sudo rfkill unblock wlan
sudo echo "country_code=US" >>/etc/hostapd/hostapd.conf
sudo echo "interface=wlan0" >>/etc/hostapd/hostapd.conf
sudo echo "ssid=livoxnet-"${HOSTNAME:8:2} >>/etc/hostapd/hostapd.conf
sudo echo "hw_mode=g" >>/etc/hostapd/hostapd.conf
# THIS IS OK FOR 2.4GHZ
# sudo echo "channel="${HOSTNAME:9:1} >>/etc/hostapd/hostapd.conf
sudo echo "channel=7" >>/etc/hostapd/hostapd.conf
# THIS IS OK FOR 5GHZ in the US  https://en.wikipedia.org/wiki/List_of_WLAN_channels#United_States
# sudo echo "channel=149" >>/etc/hostapd/hostapd.conf
sudo echo "macaddr_acl=0" >>/etc/hostapd/hostapd.conf
sudo echo "auth_algs=1" >>/etc/hostapd/hostapd.conf
sudo echo "ignore_broadcast_ssid=0" >>/etc/hostapd/hostapd.conf
# sudo echo "wpa=2" >>/etc/hostapd/hostapd.conf
# sudo echo "wpa_passphrase=lixoxPiWiFi" >>/etc/hostapd/hostapd.conf
sudo echo "wpa_key_mgmt=WPA-PSK" >>/etc/hostapd/hostapd.conf
sudo echo "wpa_pairwise=TKIP" >>/etc/hostapd/hostapd.conf
sudo echo "rsn_pairwise=CCMP" >>/etc/hostapd/hostapd.conf
