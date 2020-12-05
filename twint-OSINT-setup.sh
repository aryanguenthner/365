# Twitter OSINT
echo
cd /opt
git clone --depth=1 https://github.com/twintproject/twint.git
cd twint
pip3 install . -r requirements.txt
pip3 install twint
pip3 install --user --upgrade git+https://github.com/twintproject/twint.git@origin/master#egg=twint
echo

