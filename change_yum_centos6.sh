#!/bin/sh

rpm -aq|grep yum|xargs rpm -e --nodeps

wget http://centos.ustc.edu.cn/centos/6/os/x86_64/Packages/yum-3.2.29-60.el6.centos.noarch.rpm
wget http://centos.ustc.edu.cn/centos/6/os/x86_64/Packages/yum-metadata-parser-1.1.2-16.el6.x86_64.rpm
wget http://centos.ustc.edu.cn/centos/6/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.30-30.el6.noarch.rpm
wget http://centos.ustc.edu.cn/centos/6/os/x86_64/Packages/yum-plugin-security-1.1.30-30.el6.noarch.rpm
wget http://centos.ustc.edu.cn/centos/6/os/x86_64/Packages/yum-utils-1.1.30-30.el6.noarch.rpm

rpm -ivh yum-3.2.29-60.el6.centos.noarch.rpm yum-metadata-parser-1.1.2-16.el6.x86_64.rpm yum-plugin-fastestmirror-1.1.30-30.el6.noarch.rpm  yum-plugin-security-1.1.30-30.el6.noarch.rpm yum-utils-1.1.30-30.el6.noarch.rpm

cat > /etc/yum.repos.d/CentOS-Base.repo <<EOF  
# CentOS-Base.repo

#
# This file uses a new mirrorlist system developed by Lance Davis for CentOS.
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the 
# remarked out baseurl= line instead.
#
#

[base]
name=CentOS-6 - Base
repo=os
baseurl=http://centos.ustc.edu.cn/centos/6/os/x86_64/
gpgcheck=1
gpgkey=http://centos.ustc.edu.cn/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6
#released updates 
[updates]
name=CentOS-6 - Updates
baseurl=http://centos.ustc.edu.cn/centos/6/updates/x86_64/
gpgcheck=1
gpgkey=http://centos.ustc.edu.cn/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6

#packages used/produced in the build but not released
[addons]
name=CentOS-6 - Addons
baseurl=http://centos.ustc.edu.cn/centos/6/os/x86_64/
gpgcheck=1
gpgkey=http://centos.ustc.edu.cn/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6

#additional packages that may be useful
[extras]
name=CentOS-6 - Extras
baseurl=http://centos.ustc.edu.cn/centos/6/extras/x86_64/
gpgkey=1
gpgkey=http://centos.ustc.edu.cn/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-6 - Plus
baseurl=http://centos.ustc.edu.cn/centos/6/centosplus/x86_64/
gpgcheck=1
enabled=0
gpgkey=http://centos.ustc.edu.cn/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6

#contrib - packages by Centos Users
[contrib]
name=CentOS-6 - Contrib
baseurl=http://centos.ustc.edu.cn/centos/6/contrib/x86_64/
gpgcheck=1
enabled=0
gpgkey=http://centos.ustc.edu.cn/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6
EOF

yum update
# EPEL
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

sed -i "4s/https/http/" /etc/yum.repos.d/epel.repo
