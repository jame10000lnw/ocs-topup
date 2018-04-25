#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

 red='\e[1;31m'
               green='\e[0;32m'
               NC='\e[0m'
			   
               echo "Connect ocspanel.info..."
               sleep 1
               
			   echo "กำลังตรวจสอบ Permision..."
               sleep 1
               
			   echo -e "${green}ได้รับอนุญาตแล้ว...${NC}"
               sleep 1
			   
flag=0

if [ $USER != 'root' ]; then
	echo "คุณต้องเรียกใช้งานนี้เป็น root"
	exit
fi

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;

if [[ -e /etc/debian_version ]]; then
	#OS=debian
	RCLOCAL='/etc/rc.local'
else
	echo "คุณไม่ได้เรียกใช้สคริปต์นี้ในระบบปฏิบัติการ Debian"
	exit
fi

vps="VPS";

if [[ $vps = "VPS" ]]; then
	source="http://ocspanel.info"
else
	source="http://เฮียเบิร์ด.com"
fi

# GO TO ROOT
cd

# text gambar
apt-get install boxes

# install lolcat
sudo apt-get -y install ruby
sudo gem install lolcat

clear
echo "
----------------------------------------------
[√] ยินดีต้อนรับเข้าสู่ : ระบบสคริป Ocspanel.info 
[√] Connect...
[√] Wellcome : กรุณาทำตามขั้นตอน... [ OK !! ]
----------------------------------------------
 " | lolcat
 sleep 3

MYIP=$(wget -qO- ipv4.icanhazip.com);

flag=0	

clear

apt-get remove --purge mysql\*
dpkg -l | grep -i mysql
apt-get clean

apt-get install -y libmysqlclient-dev mysql-client

service nginx stop
service php5-fpm stop
service php5-cli stop

apt-get -y --purge remove nginx php5-fpm php5-cli

#apt-get update
apt-get update -y

apt-get install build-essential expect -y

apt-get install -y mysql-server

#mysql_secure_installation
so1=$(expect -c "
spawn mysql_secure_installation; sleep 3
expect \"\";  sleep 3; send \"\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect eof; ")
echo "$so1"
#\r
#Y
#pass
#pass
#Y
#Y
#Y
#Y

chown -R mysql:mysql /var/lib/mysql/
chmod -R 755 /var/lib/mysql/

apt-get install -y nginx php5 php5-fpm php5-cli php5-mysql php5-mcrypt


# Install Web Server
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/rasta-team/MyVPS/master/nginx.conf"
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/lnwseed/ocs-topup/master/vps.conf"
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf


chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html


clear
echo ""

cd /root

apt-get update

service webmin restart

apt-get -y --force-yes -f install libxml-parser-perl

echo "unset HISTFILE" >> /etc/profile


sleep 2
cd /home/vps/public_html/
rm -rf port.sh

sleep 3
clear
echo "
----------------------------------------------
[√] Source : Ocspanel.info 
[√] ขั้นตอนต่อไปนี้ให้ท่านตอบ..Y
[√] กำลังเริ่มติดตั้ง : Wallet..... [ OK !! ]
----------------------------------------------
 "
sudo apt-get install curl
sudo service apache2 restart
sudo apt-get install php5-curl
sudo service apache2 restart

sleep 4
# info
clear
echo "================ การติดตั้งเสร็จสิ้น พร้อมใช้งาน ================" | tee -a log-install.txt
echo "กรุณาเข้าสู่ระบบ OCS Panel ที่ http://$MYIP:81/" | tee -a log-install.txt

echo "" | tee -a log-install.txt
#echo "บันทึกการติดตั้ง --> /root/log-install.txt" | tee -a log-install.txt
#echo "" | tee -a log-install.txt
echo "โปรดรีบูต VPS ของคุณ!" | tee -a log-install.txt
echo "=========================================================" | tee -a log-install.txt
rm -f /root/port.sh
cd ~/
