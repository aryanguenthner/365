#sudo nano /etc/lightdm/lightdm.conf
echo
echo

sed -i 's/#autologin-user=/autologin-user=kali/' /etc/lightdm/lightdm.conf
sed -i 's/#autologin-user-timeout=0/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf
echo

sudo service lightdm restart
reboot
echo
