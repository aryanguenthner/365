#sudo nano /etc/lightdm/lightdm.conf
echo
echo
sed -i '120s/#autologin-user=/autologin-user=kali/g' /etc/lightdm/lightdm.conf
sed -i '121s/#autologin-user-timeout=0/autologin-user-timeout=0/g' /etc/lightdm/lightdm.conf
echo

sudo service lightdm restart
reboot
echo
