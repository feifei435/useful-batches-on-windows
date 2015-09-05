#WinXP_auth_scheduler README

##介绍
此工具可以将 处于深信服内网审计下，每次上网均需认证的流程 自动化，并且增加了掉线检测功能，特被适合需要内网机器长时间在线的场景(如在家通过teamviewer连接公司机器，若公司机器因为某些原因认证过期或被踢掉，则teamviewer会永久掉线，此脚本可以避免机器掉线，保证公司内网机器不间断的互联网连通性)
将认证功能安装为系统定时任务定时执行，功能如下：

1. 将本bat注册为系统定时任务并设置间隔时间
2. bat每次运行监测qq.com联通性，若不可达，则调用auth.py开始认证流程
3. 若监测qq.com为可达，则自动退出

##使用
认证的用户名需要在104行给出
```
namelist = ['yourusername']
```
认证的密码需要在44行给出
```
password_mgr.add_password('WebAuthorizeCenter', login_url, name, 'yourpassword')
```
使用reg_scheduler注册bat为定时器任务，默认每2min定时执行


##notes
每次检测或认证过程均会在auth.log有日志记录，方便日后排查问题。
本脚本调用了Linux中常用的访问http的工具wget，在此一并将wget.exe附上。
