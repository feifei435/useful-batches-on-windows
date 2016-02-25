#sanfor auth tool
sanfor(深信服) ac 自动登录认证工具，包含了Linux版与Windows版，需要python2.7
认证日志保存在当前目录的auth.log中
##auth.sh
    ./auth.sh
执行单次认证
##auth_daemon.sh
    ./auth_daemon.sh 2>&1 >/dev/null &

在后台开启认证守护进程，循环检测互联网连接状态，若检测到中断则立即执行认证
