# WiFi SSID xfce panel generic monitor
SSID=$(iw dev wlan0 info | grep ssid | awk '{print $2}')
echo $SSID
