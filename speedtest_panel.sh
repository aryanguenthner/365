# Speed Test Panel
speedtest --simple
# crontab -e
# */1 * * * * speedtest --simple >> /var/log/speedtest_panel.log 2>&1
tail -f /var/log/speedtest_panel.log
