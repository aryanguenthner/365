# Metasploit Setup
# Kali 2020.4

sudo gem install rails

cd /opt
sudo curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall

echo "Metasploit Ready Up"
sudo systemctl start postgresql
sudo msfdb init
msfconsole -qr
