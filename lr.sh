#!/bin/sh

case "$1" in
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
    echo "Usage: $0 {start|stop}"
esac
