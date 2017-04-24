#!/bin/bash  

# http://makezine.com/projects/browse-anonymously-with-a-diy-raspberry-pi-vpntor-router/
#https://github.com/backupbrain/netninja

# Download raspbian
wget https://downloads.raspberrypi.org/raspbian_lite_latest
# Upload to raspbian to SD card
sudo dd bs=4M if=2014-09-09-wheezy-raspbian.img | pv | dd of=/dev/mmcblk0


# Set locale
sudo apt-get install language-pack-sv_SV.uft8
echo -e "password\npassword" | sudo passwd pi

# expand disk
sudo raspiconfig

# Upgrade the systems
sudo apt-get update -y
sudo apt-get upgrade -y

# Update the Edimax support
cd ~
wget https://github.com/jenssegers/RTL8188-hostapd/archive/v2.0.tar.gz
tar -zxvf v2.0.tar.gz
cd RTL8188-hostapd-2.0/hostapd
sudo apt-get install make -y
make
sudo make install
cd ../..
sudo rm v2.0.tar.gz
sudo rm RTL8188-hostapd-2.0 -r


# Update the /etc/hostapd/hostapd.conf
sudo cp /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.bak
sudo cp resources/confs/hostapd.conf /etc/hostapd/hostapd.conf
sudo cp /etc/default/hostapd /etc/default/hostapd.bak
sudo cp resources/confs/hostapd /etc/default/hostapd

sudo service hostapd start
sudo update-rc.d hostapd enable

# Install DHCP on wlan0
sudo apt-get install dnsmasq -y

cp resources/confs/dnsmasq.conf /etc/dnsmasq.d/dnsmasq.conf
cp resources/confs/resolv.conf /etc/resolv.conf

sudo cp resources/confs/interfaces /etc/network/interfaces
sudo ifdown wlan0
sudo ifup wlan0
sudo service dnsmasq start
sudo update-rc.d dnsmasq enable

# Install NAT

sudo cp resources/confs/sysctl.conf /etc/sysctl.conf
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo ifup wlan0

# Setup IPTABLES
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 22 -j REDIRECT --to-ports 22
sudo iptables -t nat -A PREROUTING -i wlan0 -p udp --dport 53 -j REDIRECT --to-ports 53
sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --syn -j REDIRECT --to-ports 9040

# Save settings for next reboot
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
echo "up iptables-restore < /etc/iptables.ipv4.nat" | sudo tee -a /etc/network/interfaces


# Install tor
sudo apt-get install tor -y

sudo cp /etc/tor/torrc /etc/tor/torrc.bak
sudo cp resources/confs/torrc /etc/tor/torrc

sudo service tor start 
sudo update-rc.d tor enable 

#Install and setup firewall
sudo apt-get install ufw -y
sudo ufw allow ssh
sudo ufw allow 53
sudo ufw allow 9030
sudo ufw allow 9040
sudo ufw enable


# Freenet proxy
# Install Oracle Java 8
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -y 
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install oracle-java8-jdk -y

# Install pi-hole2
# Setup static ip??
# Install Webserver
sudo apt-get -y install lighttpd
# Setup Webserver
sudo chown www-data:www-data /var/www/html
sudo chmod 775 /var/www/html
sudo usermod -a -G www-data pi
sudo mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.bak
sudo cp resources/confs/lighttpd.conf /etc/lighttpd/lighttpd.conf
sudo service lighttpd restart

sudo mkdir /var/www/pihole









