################################################
# Tested on Kali 2020.4
# If you're reading this pat yourself on the back
# sudo dos2unix *.sh
# sudo chmod +x *.sh
# Usage: sudo ./mobsf-setup.sh | tee mobsf.log
# Learn more at https://github.com/aryanguenthner/
# Last Updated 12/15/2020
################################################
echo "Usage: sudo ./mobsf-setup.sh | tee mobsf.log"

# MobSF Setup

echo '# MobSF' >> /root/.bashrc
export ANDROID_SDK=/root/Android/Sdk/
export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$PATH
export PATH="/root/Android/Sdk/platform-tools":$PATH
export PATH="/opt/android-studio/jre/jre/bin":$PATH

echo '# Java Deez Nutz' >> /root/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

echo "MobSF"
pip install apkid
pip install -U git+https://github.com/VirusTotal/yara-python

cd /opt/
git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
cd Mobile-Security-Framework-MobSF/
pip3 install -r requirements.txt
sudo yes |./setup.sh &
echo
