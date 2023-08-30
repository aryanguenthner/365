# Hypnotix Free TV on Kali 2023.3
# 
# 08/30/2023

echo "Please Enable 3D Acceleration in VM Settings"
sleep 1
echo
echo "Power off VM, Open VirtualBox, Settings > Display > Extended Features Enable 3D Acceleration"
sleep 1
echo

sudo apt-get update
echo "Hacker TV"
echo

echo "Installing Dependencies"
echo
sudo apt-get install -y dbus-x11 libmpv2 gir1.2-xapp-1.0 xapps-common debhelper python3-setproctitle dpkg-dev git

wget --no-check-certificate http://ftp.us.debian.org/debian/pool/main/i/imdbpy/python3-imdbpy_6.6-1_all.deb
dpkg -i python3-imdbpy_6.6-1_all.deb
echo

# Download Hypnotix
wget --no-check-certificate https://github.com/linuxmint/hypnotix/releases/download/master.mint21/packages.tar.gz
tar -xf packages.tar.gz -C /opt

chmod -R 777 /opt/packages && cd /opt/packages
dpkg -i *.deb

# Insurance
apt-get --fix-broken install -y
updatedb
echo

echo "Pro Tip: Add this Provider -> https://iptv-org.github.io/iptv/index.m3u"
sleep 1
echo
echo "sudo su -c "hypnotix" $USER" > /home/$USER/hacker.tv && chmod a+x hacker.tv && chmod 777 hacker.tv
echo "Watch TV: ./hacker.tv"
 
sudo su -c "hypnotix" $USER
echo

