#sudo nano -c /etc/lightdm/lightdm.conf
echo
echo

sed -i 's/#autologin-user=/autologin-user=kali/' /etc/lightdm/lightdm.conf  # Line 120
sed -i 's/#autologin-user-timeout=0/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf  # Line 121
echo
sudo groupadd -r autologin
sudo gpasswd -a kali autologin

sudo service lightdm restart

# Fix Unlock login keyring
# cd /home/kali/Downloads
# cp /home/kali/.local/share/keyrings/login.keyring login.keyring.backup
# rm /home/kali/.local/share/keyrings/login.keyring                    

reboot
echo
