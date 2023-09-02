# Hypnotix Free TV on Kali 2023.3
# 
# 08/31/2023
echo
echo "Please Enable 3D Acceleration in VM Settings"
sleep 1
echo
echo "Power off VM, Open VirtualBox, Settings > Display > Extended Features Enable 3D Acceleration"
sleep 1
echo
sudo apt-get update
echo "Hacker TV"
echo

# Hypnotix checker
TV=/bin/hypnotix
if [ -f "$TV" ]
then
    echo "Found hypnotix"

else

# Download Hypnotix
wget --no-check-certificate https://github.com/linuxmint/hypnotix/releases/download/master.mint21/packages.tar.gz > /dev/null 2>&1
tar -xf packages.tar.gz > /dev/null 2>&1
rm packages.tar.gz

chmod -R 777 /opt/packages && cd /opt/packages
dpkg -i *.deb

echo "Installing Dependencies"
echo
sudo apt-get install -y dbus-x11 libmpv2 gir1.2-xapp-1.0 xapps-common debhelper python3-setproctitle dpkg-dev git

cd /opt
wget --no-check-certificate http://ftp.us.debian.org/debian/pool/main/i/imdbpy/python3-imdbpy_6.6-1_all.deb > /dev/null 2>&1
dpkg -i python3-imdbpy_6.6-1_all.deb > /dev/null 2>&1
rm python3-imdbpy_6.6-1_all.deb
echo
# Insurance
sudo apt-get --fix-broken install -y
updatedb

fi
echo

# hacker.tv checker
H=/home/kali/Desktop/hacker.tv
if [ -f "$H" ]
then
    echo "Found hacker.tv"

else

# Create hacker.tv launcher
echo "Creating hacker.tv launcher"

cat <<EOF > /home/kali/Desktop/hacker.tv
Type=Application
Name=hacker.tv
Terminal=false
Exec=sudo su -c "hypnotix" kali > /dev/null 2>&1
Comment=Watch TV
Path=/home/kali/Desktop/hacker.tv
StartupNotify=false
MimeType=text/plain
EOF

chmod a+x /home/kali/Desktop/hacker.tv
chmod -R 777 /home/kali/Desktop/hacker.tv    
    
fi
echo

echo "Confirm Enable 3D Acceleration in VM Settings"
echo "Power off VM, Open VirtualBox, Settings > Display > Extended Features Enable 3D Acceleration"
echo "If you already did this step, Ignore this message"
sleep 1
echo
echo "Tip"
echo "Add this Provider -> https://iptv-org.github.io/iptv/index.m3u"
echo
echo "IPTV Provider with full version: https://iptv-org.github.io/iptv/index.nsfw.m3u"
sleep 1
echo
echo "Watch TV enter: ./hacker.tv"
sleep 1
echo
bash hacker.tv > /dev/null 2>&1
echo

cd /home/kali/Desktop
exec bash

