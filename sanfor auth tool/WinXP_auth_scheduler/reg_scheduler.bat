::创建定时任务的命令
::schtasks的具体用法见schtasks /?
schtasks /create /sc minute /mo 2 /tn "auth" /tr c:\auth.bat