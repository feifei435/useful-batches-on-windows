@echo off
echo 1 打开wifi热点
echo 2 关闭wifi热点
set /p select=请输入选择
if /i "%select%" == "1" goto openap
if /i "%select%" == "2" goto closeap
:openap
netsh wlan set hostednetwork mode=allow ssid=kk435 key=ssssaaaa
netsh wlan start hostednetwork
pause
exit
goto exit
:closeap
netsh wlan stop hostednetwork
goto exit
:exit
echo 设置完成