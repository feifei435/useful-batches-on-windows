#!/bin/bash
PY_SCRIPT=/root/auth_linux_utf8.py
LOG_FILE=/root/auth.log
wget -S --max-redirect 0 http://qq.com 2>&1|grep -q "Location: http:\/\/www\.qq\.com"
if [ $? -eq 0 ]
then
    echo `date` check success >> $LOG_FILE
else
    echo `date` reauth >> $LOG_FILE
    python2.7 $PY_SCRIPT
fi
