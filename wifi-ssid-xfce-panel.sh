# WiFi SSID xfce panel generic monitor
SSID=$(iw dev wlan0 info | grep ssid | awk '{print $2}')
IP=$(hostname -I | awk '{print $1}')
EXT=$(curl -s https://api64.ipify.org || curl -s https://ifconfig.me || curl -s https://checkip.amazonaws.com)
echo $SSID
echo $IP
echo $EXT
