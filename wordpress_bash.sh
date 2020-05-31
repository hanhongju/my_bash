#wordpress安装脚本@Debian 9
#定义网站URL
site=hanhongju.com
#安装常用软件包、LNMP环境：
apt   update
apt   full-upgrade   -y
apt   autoremove     -y
apt   install        -y      python3-pip    net-tools    policycoreutils     mariadb-server      nginx      php-fpm      php-mysql 
#安装Certbot
pip3 install cryptography --upgrade
pip3 install certbot
#申请SSL证书
service nginx stop
certbot certonly    --standalone    --agree-tos    -n    -d     $site    -m    86606682@qq.com 
#配置证书自动更新
echo "0 0 1 */2 * service nginx stop; certbot renew; service nginx start;" | crontab
#关闭SELinux
setsebool -P httpd_can_network_connect 1 && setenforce 0
#下载wordpress至网站根目录
wget    https://cn.wordpress.org/latest-zh_CN.tar.gz     -P     /home/website/
chmod   777   -R   /home/website/
#解压缩wordpress安装包`
cd   /home/website   
tar zxf  latest-zh_CN.tar.gz
#拷贝wordpress程序至网站根目录
mv     wordpress/*  .                                                     
#删除wp压缩包
rm    -rf     wordpress     latest-zh_CN.tar.gz
#下载探针
wget     https://raw.githubusercontent.com/kmvan/x-prober/master/dist/prober.php    -O     /home/website/p.php
#创建nginx配置文件
echo '
server {
server_name www.example.com;
listen 80;
listen [::]:80;
listen 443 ssl;
listen [::]:443 ssl;
ssl_certificate /etc/letsencrypt/live/www.example.com/fullchain.pem;  
ssl_certificate_key /etc/letsencrypt/live/www.example.com/privkey.pem;   
if ( $scheme = http ){
return 301 https://$server_name$request_uri;
}
root   /home/website/;
index   index.php index.html index.htm;
location ~ \.php$ {
fastcgi_pass  unix:/run/php/php7.0-fpm.sock;
#php -v    遇到502 Bad Gateway时查看php版本，确认php-fpm.sock版本
fastcgi_index  index.php;
fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
include        fastcgi_params;
}
}
'    >        /etc/nginx/sites-enabled/default
#修改nginx配置文件
sed   -i     ''s/www.example.com/$site/g''        /etc/nginx/sites-enabled/default
service   nginx   restart
#配置数据库
mysql_secure_installation
#修改数据库登录方式
mysql  -uroot -pfengkuang   -e "update mysql.user set plugin='mysql_native_password' where User='root'"
#创建新数据库
mysqladmin -u root -pfengkuang create wordpress
#重启服务
systemctl enable nginx 
systemctl enable mariadb
service nginx    restart
service mariadb  restart



#转移网站->备份数据库，存放于wordpress.sql
mysqldump  -u root -pfengkuang  wordpress > /home/wordpress.sql
#将备份文件导入数据库
mysql -u root -pfengkuang wordpress < /home/wordpress.sql
#浏览器进入网站开始配置
#设置-固定链接，改为朴素