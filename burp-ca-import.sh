sudo cp cacert.der /usr/local/share/ca-certificates/cacert.crt
sudo update-ca-certificates
google-chrome --import-certificate /usr/local/share/ca-certificates/cacert.crt

