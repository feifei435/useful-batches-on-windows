@echo off
echo 1 ��wifi�ȵ�
echo 2 �ر�wifi�ȵ�
set /p select=������ѡ��
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
echo �������