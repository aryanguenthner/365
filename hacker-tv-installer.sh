# Hypnotix Free TV on Kali 2023.3
# 
# 09/15/2024
echo
sudo apt-get update
echo
echo "Hacker TV"
echo

# Hypnotix checker
TV=/bin/hypnotix
if [ -f "$TV" ]
then
    echo "Found hypnotix"

else

# Download Hypnotix
echo "Installing Dependencies"
echo
sudo apt-get install -y dbus-x11 libmpv2 gir1.2-xapp-1.0 xapps-common debhelper python3-setproctitle dpkg-dev git

cd /opt
git clone https://github.com/linuxmint/hypnotix/ && cd hypnotix/

wget --no-check-certificate http://packages.linuxmint.com//pool/main/c/circle-flags/circle-flags-svg_2.3.0_all.deb
dpkg -i circle-flags-svg_2.3.0_all.deb

cd /opt/hypnotix
wget --no-check-certificate http://ftp.us.debian.org/debian/pool/main/i/imdbpy/python3-imdbpy_6.6-1_all.deb > /dev/null 2>&1
dpkg -i python3-imdbpy_6.6-1_all.deb > /dev/null 2>&1
rm python3-imdbpy_6.6-1_all.deb
echo

wget --no-check-certificate https://github.com/linuxmint/hypnotix/releases/download/master.lmde6/packages.tar.gz > /dev/null 2>&1
tar -xf packages.tar.gz > /dev/null 2>&1


cd packages/
dpkg -i *.deb

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
echo "Creating hacker.tv --> /home/kali/Desktop/hacker.tv"
cat <<EOF > /home/kali/Desktop/hacker.tv
Type=Application
Name=hacker.tv
Terminal=false
Exec=sudo su -c "hypnotix" kali > /dev/null 2>&1
Comment="Watch TV"
Path=/home/kali/Desktop/hacker.tv
StartupNotify=false
MimeType=text/plain
EOF

chmod a+x /home/kali/Desktop/hacker.tv
chmod -R 777 /home/kali/Desktop/hacker.tv    
    
fi
echo

# 3D Acceleration Checker
D3=$(glxinfo | grep "direct rendering: Yes")
if [ "$D3" == "direct rendering: Yes" ]
then

echo
    echo "3D Ready"
echo

else

    echo "3D not Enabled"
echo "Power off VM, Open VirtualBox, Settings > Display > Extended Features Enable 3D Acceleration"

fi

    echo "Pro Tip"
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

