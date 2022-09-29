#! /bin/bash

echo "What's the name of the box?"

read boxname

echo "Enter IP:"

read boxip

sudo echo "${boxname}.htb $boxip" >> /etc/hosts

mkdir $boxname
cd $boxname


docker pull adarnimrod/masscan
sudo docker run -it --network host --rm adarnimrod/masscan --rate=10000 -p1-65535 $boxip -e tun0 > masscanResultTcp
#sudo masscan --wait 0 -p1-65535,U:1-65535 $boxip --rate=1000 -e tun0 >> masscanResult
cat masscanResultTcp | grep -o -P '(?<=t ).*(?=/)' > portsToScan

allPorts=""
while IFS= read -r line || [[ "$line" ]] ; do
    allPorts+="${line},"
done < portsToScan

echo "Scanning ports: $allPorts"

nmap -sS -sV -sC $boxip -p${allPorts} > NmapResults
cat NmapResults


