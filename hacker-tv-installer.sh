# Hypnotix Free TV on Kali 2023.3
# 
# 08/30/2023
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

echo "Installing Dependencies"
echo
sudo apt-get install -y dbus-x11 libmpv2 gir1.2-xapp-1.0 xapps-common debhelper python3-setproctitle dpkg-dev git

cd /opt
wget --no-check-certificate http://ftp.us.debian.org/debian/pool/main/i/imdbpy/python3-imdbpy_6.6-1_all.deb
dpkg -i python3-imdbpy_6.6-1_all.deb
rm python3-imdbpy_6.6-1_all.deb
echo

# Download Hypnotix
wget --no-check-certificate https://github.com/linuxmint/hypnotix/releases/download/master.mint21/packages.tar.gz
tar -xf packages.tar.gz
rm packages.tar.gz

# Get icon
wget -O /home/kali/Pictures/tv.png https://raw.githubusercontent.com/aryanguenthner/365/e7a68a70eda392ba6b4b1cbb99e405e3ad677c4d/tv.png

chmod -R 777 /opt/packages && cd /opt/packages
dpkg -i *.deb

# Insurance
sudo apt-get --fix-broken install -y
updatedb
echo
echo "Pro Tip"
echo
echo "Add this Provider -> https://iptv-org.github.io/iptv/index.m3u"
echo
echo "IPTV Provider with full version: https://iptv-org.github.io/iptv/index.nsfw.m3u"
sleep 1
echo

# Create hacker.tv launcher
echo "Creating hacker.tv launcher"
cat <<EOF > /home/kali/Desktop/App.Desktop
[Desktop Entry]
Type=Application
Name=hacker.tv
Terminal=false
Exec=sudo su -c "hypnotix" kali > /dev/null 2>&1
Icon=/home/kali/Pictures/tv.png
Comment=Watch TV
Path=/home/kali/Desktop/App.Desktop
StartupNotify=false
EOF
chmod -R 777 /home/kali/Desktop/App.Desktop
echo "Watch TV enter: ./App.Desktop"
sleep 1
echo
echo
echo
echo