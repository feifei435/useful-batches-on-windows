#!/bin/sh

rpm -aq|grep yum|xargs rpm -e --nodeps

wget http://centos.ustc.edu.cn/centos/5/os/x86_64/CentOS/yum-3.2.22-40.el5.centos.noarch.rpm
wget http://centos.ustc.edu.cn/centos/5/os/x86_64/CentOS/yum-metadata-parser-1.1.2-4.el5.x86_64.rpm
wget http://centos.ustc.edu.cn/centos/5/os/x86_64/CentOS/yum-fastestmirror-1.1.16-21.el5.centos.noarch.rpm
wget http://centos.ustc.edu.cn/centos/5/os/x86_64/CentOS/yum-security-1.1.16-21.el5.centos.noarch.rpm
wget http://centos.ustc.edu.cn/centos/5/os/x86_64/CentOS/yum-utils-1.1.16-21.el5.centos.noarch.rpm


rpm -ivh yum-3.2.22-40.el5.centos.noarch.rpm yum-metadata-parser-1.1.2-4.el5.x86_64.rpm yum-fastestmirror-1.1.16-21.el5.centos.noarch.rpm yum-security-1.1.16-21.el5.centos.noarch.rpm yum-utils-1.1.16-21.el5.centos.noarch.rpm

cat > /etc/yum.repos.d/CentOS-Base.repo <<EOF
# CentOS-Base.repo
#
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
name=CentOS-5 - Base - mirrors.ustc.edu.cn
baseurl=http://mirrors.ustc.edu.cn/centos/5/os/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=5&arch=\$basearch&repo=os
gpgcheck=1
gpgkey=http://mirrors.ustc.edu.cn/centos/RPM-GPG-KEY-CentOS-5

#released updates
[updates]
name=CentOS-5 - Updates - mirrors.ustc.edu.cn
baseurl=http://mirrors.ustc.edu.cn/centos/5/updates/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=5&arch=\$basearch&repo=updates
gpgcheck=1
gpgkey=http://mirrors.ustc.edu.cn/centos/RPM-GPG-KEY-CentOS-5

#additional packages that may be useful
[extras]
name=CentOS-5 - Extras - mirrors.ustc.edu.cn
baseurl=http://mirrors.ustc.edu.cn/centos/5/extras/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=5&arch=\$basearch&repo=extras
gpgcheck=1
gpgkey=http://mirrors.ustc.edu.cn/centos/RPM-GPG-KEY-CentOS-5

#packages used/produced in the build but not released
[addons]
name=CentOS-5 - Addons - mirrors.ustc.edu.cn
baseurl=http://mirrors.ustc.edu.cn/centos/5/addons/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=5&arch=\$basearch&repo=addons
gpgcheck=1
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-5

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-5 - Plus - mirrors.ustc.edu.cn
baseurl=http://mirrors.ustc.edu.cn/centos/5/centosplus/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=5&arch=\$basearch&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=http://mirrors.ustc.edu.cn/centos/RPM-GPG-KEY-CentOS-5

#contrib - packages by Centos Users
[contrib]
name=CentOS-5 - Contrib - mirrors.ustc.edu.cn
baseurl=http://mirrors.ustc.edu.cn/centos/5/contrib/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=5&arch=\$basearch&repo=contrib
gpgcheck=1
enabled=0
gpgkey=http://mirrors.ustc.edu.cn/centos/RPM-GPG-KEY-CentOS-5
EOF

yum update

# 安装epel
rpm -ivh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
