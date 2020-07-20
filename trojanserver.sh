#trojan安装脚本@Debian 10
#定义网站地址
echo    "本脚本可以自动安装trojan，自动申请并使用tls证书加密保护trojan的流量，反代朝鲜劳动新闻网址进行网站伪装。需要您事先将此VPS的IP地址解析到一个有效域名上。
如果此VPS使用KVM虚拟技术，此脚本自动开启BBR加速。
理解这些信息后请按回车键继续，并在下一栏输入您解析的有效域名。如果域名输入有误请按Ctrl+C终止脚本运行，然后重新运行脚本。"
read    nothing
echo    "请输入此VPS的IP对应的域名地址："
read    site
echo    "好的，现在要开始安装了。"
sleep   5s





#计时
begin_time=$(date +%s)
#安装常用软件包：
apt    update
apt    full-upgrade    -y
apt    autoremove      -y
apt    purge           -y         apache2 nginx
apt    install         -y         python3-pip net-tools trojan
#安装Certbot
pip3   install     cryptography --upgrade
pip3   install     certbot
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
sysctl   -p
#申请SSL证书
certbot    certonly    --standalone    --agree-tos     -n     -d      $site     -m    86606682@qq.com 
rm       -rf     /home/key/
mkdir    -p      /home/key/
cp       /etc/letsencrypt/live/$site/fullchain.pem       /home/key/fullchain.pem
cp       /etc/letsencrypt/live/$site/privkey.pem         /home/key/privkey.pem
chmod    -Rf     777       /home/
#配置证书自动更新
echo       "
0 0 1 * * service trojan stop
0 0 1 * * certbot renew
0 0 1 * * cp   /etc/letsencrypt/live/$site/fullchain.pem    /home/key/fullchain.pem
0 0 1 * * cp   /etc/letsencrypt/live/$site/privkey.pem      /home/key/privkey.pem
0 0 1 * * service trojan start
"  |  crontab
crontab    -l
#修改trojan配置文件
echo '
{
    "run_type": "server",
    "local_addr": "::",
    "local_port": 443,
    "remote_addr": "www.rodong.rep.kp",
    "remote_port": 80,
    "password": ["fengkuang"],
    "ssl": {
        "cert": "/home/key/fullchain.pem",
        "key": "/home/key/privkey.pem",
        "alpn": ["http/1.1"]
    }
}
'           >          /etc/trojan/config.json
#启动trojan
systemctl    enable      trojan
systemctl    restart     trojan
#显示监听端口
sleep 1s
/usr/bin/trojan  -t  
netstat -plunt | grep 'trojan'
OUTPUT=$(netstat -plunt | grep 'trojan'    2>&1)
if     [[  "$OUTPUT"   =~   "trojan"   ]]   ;        
then        echo   "至此，trojan可正常工作。服务器密码为fengkuang。"
else        echo   "您输入的域名地址可能没有正确解析或者短时间申请了太多的证书，不能正常申请证书，所以trojan不能正常工作。在您确认了域名解析没有问题后再请重新运行本脚本。"
fi
finish_time=$(date +%s)
time_consume=$((   finish_time   -   begin_time ))
echo   "脚本运行时间$time_consume秒。"
#至此trojan可正常工作



