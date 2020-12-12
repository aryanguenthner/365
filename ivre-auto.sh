# interactive ivre
# accepts user input
# It's recommended to use screen when running ivre just incase your terminal dies.

IP='hostname -I'
EXTERNAL='curl ifconfig.me'

echo "Your IP"
$IP
echo
echo "Your External IP"
$EXTERNAL
echo
echo "Useage: ./ivre-auto.sh"
echo
echo -n "What are you scanning ie. -iL file.txt,192.168.1.0/24,russia.ru/24: "
read scan
echo -n "Enter The Name of Your ivre scan: "
read name
echo -n "Enter Output File Location example /root/kali/Desktop: "
read path
echo
echo "Good Time to get a cup of coffee while this runs"
echo
echo
echo "If you see output then it's working fine."
echo
echo
nmap $scan --mtu=24 -T4 -A -PS -PE -p- -vv -r --open --max-retries=0 --max-parallelism=32 --host-timeout=15m -sC --script-timeout=2m --script=ssl-cert,ssl-enum-ciphers,ssl-heartbleed,sip-enum-users,sip-brute,sip-methods,rtsp-screenshot,rtsp-url-brute,rpcinfo,vnc-screenshot,x11-access,x11-screenshot,nfs-showmount,nfs-ls,smb-vuln-ms08-067,smb-vuln-ms17-010,smb-ls,smb-enum-shares,http-robots.txt.nse,http-webdav-scan,http-screenshot,http-auth,http-form-brute,http-sql-injection,http-ntlm-info,http-git,http-open-redirect,http-open-proxy,socks-open-proxy,smtp-open-relay,ftp-anon,ftp-bounce,ms-sql-config,ms-sql-info,ms-sql-empty-password,mysql-info,mysql-empty-password,vnc-brute,vnc-screenshot,vmware-version,http-shellshock,http-default-accounts,http-passwd,vuln  -oA $path$name && ivre scan2db $name.xml && ivre db2view nmap && xsltproc $name.xml -o $name.html
