#BestTrace4Linux 查看VPS回程节点@Debian 10
apt     install    -y     unzip zip wget
mkdir   /home/besttrace
cd      /home/besttrace
wget    -c   https://raw.githubusercontent.com/hanhongju/my_script/master/besttrace4linux.zip
unzip   -o   besttrace4linux.zip
chmod   +x   besttrace
./besttrace      1.63.2.132
