#!/bin/bash
IP=`ifconfig |egrep  "inet "|head -1|awk -F . '{print $3}'`
rm -rf /etc/yum.repos.d/*
yum-config-manager --add ftp://192.168.$IP.254/rhel7 &> /dev/null
sed -i '$a gpgcheck=0' /etc/yum.repos.d/192.168.$IP.254_rhel7.repo
yum repolist &> /dev/null
if [  $? -eq  0 ] ; then
echo "YUM可用------------------------------YUM可用"
fi
echo "开始一建安装LNMP～～"
yum -y install mariadb mariadb-server mariadb-devel &> /dev/null
if [ $? -eq 0 ] ; then
echo "mariadb安装完毕------------------------mariadb安装完毕"
fi
yum -y install gcc pcre-devel openssl-devel &> /dev/null
useradd -s /sbin/nologin nginx &> /dev/null
tar xf /root/lnmp_soft/nginx-1.12.2.tar.gz  -C /root  &> /dev/null
cd /root/nginx-1.12.2/
./configure --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module  --with-stream &> /dev/null
make && make install &> /dev/null
ln -s /usr/local/nginx/sbin/nginx  /sbin/
nginx -V 
echo "nginx 安装完成------------------------nginx 安装完成"
cd /root/lnmp_soft/
yum -y install php php-mysql php-fpm-5.4.16-42.el7.x86_64.rpm &> /dev/null
echo "php安装完毕---------------------------php安装完毕"

