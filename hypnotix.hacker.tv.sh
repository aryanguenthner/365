# Hypnotix Free TV on Kali 2020.4
# 12/04/2020
echo
apt update
echo
apt -y install libmpv1 gir1.2-xapp-1.0 debhelper python3-setproctitle dpkg-dev git
echo
cd /opt
git clone https://github.com/linuxmint/hypnotix.git
cd hypnotix
echo
wget http://ftp.us.debian.org/debian/pool/main/i/imdbpy/python3-imdbpy_6.8-2_all.deb &&
dpkg -i python3-imdbpy_6.8-2_all.deb 
dpkg-buildpackage -khypnotix@hypnotix.com
sudo dpkg -i ../hypnotix*.deb
echo
exit
echo "Hacker TV"
sudo hypnotix &
echo
