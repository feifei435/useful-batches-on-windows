#!/bin/sh
#loadrunner11 loadgenerator Linux版自动安装脚本
#loadrunner11 iso下载:http://pan.baidu.com/s/1kUbKCvl (密码6akd)

cd /media/Linux

# install lr dependencies
yum install glibc.i686
yum install compat-libstdc++-33.i686

./installer.sh

useradd -g 0 -s /bin/csh lr

grep -q HP_LoadGenerator /etc/csh.cshrc && echo found || echo source /opt/HP/HP_LoadGenerator/env.csh >> /etc/csh.cshrc 
grep -q DISPLAY /etc/csh.cshrc && echo found || echo setenv DISPLAY 0.0 >> /etc/csh.cshrc 

# verify lr
sed -i '$s/x\:0/x\:500/' /etc/passwd
su - lr <<EOF
cd /opt/HP/HP_LoadGenerator/bin/;
./verify_generator
exit;
EOF

# let lr user be root
#sed -i '$s/x\:500/x\:0/' /etc/passwd

# generate lr control script
rm -f lr.sh
cat > /root/lr.sh <<EOFA
#!/bin/sh

case "\$1" in
    start)
        echo starting... 
        su - lr <<EOF
        cd /opt/HP/HP_LoadGenerator/bin/;
        ./m_daemon_setup start;
        exit;
EOF
        ;;    
    stop)
        echo stoping...
        su - lr <<EOF
        cd /opt/HP/HP_LoadGenerator/bin/;
        ./m_daemon_setup stop;
        exit;
EOF
        ;;    
    *)
    echo "Usage: \$0 {start|stop}"
esac
EOFA
pwd
chmod u+x /root/lr.sh

echo "use lr.sh {start|stop} to control loadrunner."
