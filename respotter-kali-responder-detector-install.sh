# cd /opt/Respotter
# ./respotter.py -s 192.168.0.0/24

pip install slack-sdk
pip install discord-webhook
pip install --upgrade pip

cd /opt
git clone https://github.com/lawndoc/Respotter
cd Respotter
pip3 install -r requirements.txt


echo "Scan and Detect Responder MiTM"
echo "./respotter.py -s 192.168.0.0/24"
