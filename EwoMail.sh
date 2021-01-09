# EwoMail 安装脚本 @ CentOS 8
site=ali.hongju.live
#关闭Selinux
sed       -i       ''s/SELINUX\=.*/SELINUX\=disabled/g''        /etc/sysconfig/selinux
#添加SWAP缓存空间
if        [[   $(free -m   2>&1)    =~     Swap\:.*[1-9].*   ]]
then      echo   ''已经有SWAP，无需重复配置''
else      dd    if=/dev/zero of=/mnt/swap bs=1M count=3000
          mkswap   /mnt/swap
          swapon   /mnt/swap
          echo    '/mnt/swap swap swap defaults 0 0'      >>       /etc/fstab
fi
#安装EwoMail
yum    install   git    -y 
cd     /root/
git    clone     https://gitee.com/laowu5/EwoMail.git
cd     /root/EwoMail/install/
sed    -i    ''s/yum\ install\ epel-release.*/yum\ install\ epel-release\ \-y/g''     start.sh
bash   start.sh    $site
#安装后的常规配置
echo     ''127.0.0.1    mail.$site smtp.$site imap.$site''     >>       /etc/hosts
sed       -i          ''s/listen.*/listen\ 80\;/g''         /ewomail/nginx/conf/vhost/rainloop.conf
#重启服务
systemctl  restart      postfix dovecot nginx
echo     ''服务器管理页面为：      http://$site:8010''
echo     ''账户为admin，密码为ewomail123。''




