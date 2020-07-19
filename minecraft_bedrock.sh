#Minecraft基岩版服务器架设@Debian 10
#安装常用软件包
apt update
apt full-upgrade   -y
apt autoremove     -y
apt install        -y   wget unzip zip libcurl4-openssl-dev
#下载基岩版客户端
wget     https://minecraft.azureedge.net/bin-linux/bedrock-server-1.14.60.5.zip      -cP     /home/
unzip   -qo   /home/bedrock-server-1.14.60.5.zip    -d    /home/mcserver/
chmod   -Rf    777    /home/
#启动服务器
cd /home/mcserver/
(LD_LIBRARY_PATH=. ./bedrock_server&)
#关闭shell，连接服务器，开玩





#关闭服务器
pkill -9 bedrock_server




#备份服务器，将worlds目录压缩为worlds.zip文件
cd      /home/mcserver/
zip     -q      /home/worlds.zip     -r     ./worlds/
#到新服务器，上传备份文件至/home/，创建mc文件夹,解压
rm      -rf     /home/mcserver/worlds
unzip   -qo     /home/worlds.zip     -d     /home/mcserver/
#启动服务器，开玩
#win10版MC本地数据库文件在：
#C:\Users\hongju\AppData\Local\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftWorlds






