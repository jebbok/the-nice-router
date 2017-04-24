sudo apt-get install unzip
# Download raspbian
wget https://downloads.raspberrypi.org/raspbian_lite_latest
# Unzip rasbian
unzip raspbian_lite_latest -d raspbian_lite_latest
# Upload to raspbian to SD card
sudo dd bs=4M if=raspbian_lite_latest/2017-04-10-raspbian-jessie-lite.img | pv | dd of=/dev/mmcblk0 #fix image and sdcard names to dynamic