# Metasploit Setup
# Kali 2020.4

cd /opt
sudo curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall

echo "Metasploit Ready Up"
cd /home/kali/Desktop
sudo systemctl start postgresql
sudo msfdb init
msfconsole -qr
