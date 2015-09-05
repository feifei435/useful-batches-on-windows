@echo off
rem color 2a
rem mode con cols=50 lines=20

::==================================��ȡ�����ӿں�=================================
setlocal enabledelayedexpansion
::Ѱ����������
for /f "usebackq tokens=1,* delims=." %%i in (`route print^|find "Realtek PCIe GBE Family Controller"`) do (
set ITF_LAN=%%i
rem echo !ITF_LAN!
)
::ȥ����������߿ո�
:intercept1
if "%ITF_LAN:~0,1%"==" " set "ITF_LAN=%ITF_LAN:~1%" && goto intercept1
rem

::Ѱ����������
for /f "usebackq tokens=1,* delims=." %%i in (`route print^|find "Broadcom 802.11n ����������"`) do (
set ITF_WLAN=%%i
rem echo !ITF_WLAN!
)
::ȥ����������߿ո�
:intercept2
if "%ITF_WLAN:~0,1%"==" " set "ITF_WLAN=%ITF_WLAN:~1%" && goto intercept2
rem echo ���������ӿںţ�%ITF_WLAN%

::Ѱ�����������
for /f "usebackq tokens=1,* delims=." %%i in (`route print^|find "VMnet2"`) do (
set ITF_VM=%%i
echo !ITF_VM!
)
::ȥ����������߿ո�
:intercept2
if "%ITF_WLAN:~0,1%"==" " set "ITF_WLAN=%ITF_WLAN:~1%" && goto intercept2
rem echo ���������ӿںţ�%ITF_WLAN%

::��������IP��Ϣ���û��ɱ༭
set "LAN_ADDR_PREFIX=192.168.50."
set "LAN_ADDR_OTHERS=192.168.0.0"
set "LAN_ADDR_SUFFIX=175"
set "LAN_ADDR_GATEWAY=254"
set "LAN_ADDR_DNS1=223.5.5.5"
set "LAN_ADDR_DNS2=223.6.6.6"
::��������IP��Ϣ���û��ɱ༭
set "WLAN_ADDR_PREFIX=27.39.37."
set "WLAN_ADDR_SUFFIX=41"
::���������IP��Ϣ
set "VIRTUAL_MACHINE_IP=10.10.10.15"
rem set "WLAN_ADDR_SUFFIX=74"
set "WLAN_ADDR_GATEWAY=1"
set "WLAN_ADDR_DNS1=210.21.196.6"
set "WLAN_ADDR_DNS2=221.5.88.88"
::=================================================================================

echo 1 �л�������������Ϊ��֤6����ͨ�ȵ�IP:%WLAN_ADDR_PREFIX%%WLAN_ADDR_SUFFIX%
echo 2 �л�������������ΪDHCP
echo 3 �л���������Ϊ%LAN_ADDR_PREFIX%%LAN_ADDR_SUFFIX%
echo 4 �л�������������ΪDHCP
echo 5 ʹ����������
echo 6 ʹ��CMCC-WiNS����
echo 7 ʹ��CMCC����
echo 8 ���������·��(ͬʱʹ�������·������)
set /p select=������ѡ��
if /i "%select%" == "1" goto WLAN_UNICOM
if /i "%select%" == "2" goto WLAN_DHCP
if /i "%select%" == "3" goto LANIP
if /i "%select%" == "4" goto LAN_DHCP
if /i "%select%" == "5" goto surfLAN
if /i "%select%" == "6" goto surfWiNS
if /i "%select%" == "7" goto surfCMCC
if /i "%select%" == "8" goto add_LAN_route

:WLAN_UNICOM
rem netsh interface ip set address name="������������" source=static addr=27.39.37.74 mask=255.255.255.0 gateway=27.39.37.1 gwmetric=0
rem netsh interface ip set dns name="������������" source=static addr=210.21.196.6 register=primary
rem netsh interface ip add dns name="������������" addr=221.5.88.88
netsh interface ip set address name="������������" source=static addr=27.39.37.41 mask=255.255.255.0 gateway=%WLAN_ADDR_PREFIX%%WLAN_ADDR_GATEWAY% gwmetric=0
netsh interface ip set dns name="������������" source=static addr=%WLAN_ADDR_DNS1% register=primary
netsh interface ip add dns name="������������" addr=%WLAN_ADDR_DNS2%
route delete 0.0.0.0
route add 0.0.0.0 mask 0.0.0.0 %WLAN_ADDR_GATEWAY% metric 205 if %ITF_WLAN%

goto exit
:WLAN_DHCP
netsh interface ip set address "������������" DHCP
netsh interface ip set dns "������������" DHCP
:LANIP
netsh interface ip set address name="��������" source=static addr=%LAN_ADDR_PREFIX%%LAN_ADDR_SUFFIX% mask=255.255.255.0 gateway=%LAN_ADDR_PREFIX%%LAN_ADDR_GATEWAY% gwmetric=0
netsh interface ip set dns name="��������" source=static addr=%LAN_ADDR_DNS1% register=primary
netsh interface ip add dns name="��������" addr=%LAN_ADDR_DNS2%
ping 127.0.0.1 > nul
goto exit
:LAN_DHCP
netsh interface ip set address "��������" DHCP
netsh interface ip set dns "��������" DHCP
goto exit
::=================================================================================
:add_LAN_route
echo ��ȷ��������Ϣ(���������ֶ��༭bat�޸�)��
echo ���������ӿںţ�%ITF_LAN%
echo ���������ӿںţ�%ITF_WLAN%
echo ��������:%LAN_ADDR_PREFIX%0
echo ��������IP:%LAN_ADDR_PREFIX%%LAN_ADDR_SUFFIX%
set /p confirm=(y/n)?
if /i "%confirm%" == "y" goto add_LAN_route_true
echo  δ���κθ���
ping 127.0.0.1 > nul
goto exit
:add_LAN_route_true
route delete 0.0.0.0 %LAN_ADDR_PREFIX%%LAN_ADDR_GATEWAY%
route delete %LAN_ADDR_OTHERS%
route add %LAN_ADDR_OTHERS% mask 255.255.0.0 %LAN_ADDR_PREFIX%%LAN_ADDR_GATEWAY% if %ITF_LAN%
route add 0.0.0.0 mask 0.0.0.0 %VIRTUAL_MACHINE_IP% if %ITF_VM%
route print
ping 127.0.0.1 > nul
goto exit
::=================================================================================

::=================================================================================
:surfLAN
echo ��ȷ��������Ϣ(���������ֶ��༭bat�޸�)��
echo ���������ӿںţ�%ITF_LAN%
echo ���������ӿںţ�%ITF_WLAN%
echo ��������:%LAN_ADDR_PREFIX%0
echo ��������IP:%LAN_ADDR_PREFIX%%LAN_ADDR_SUFFIX%
set /p confirm=(y/n)?
if /i "%confirm%" == "y" goto surfLANtrue
echo  δ���κθ���
goto exit
:surfLANtrue
route delete 0.0.0.0
route delete %LAN_ADDR_OTHERS%
route add 0.0.0.0 mask 0.0.0.0 %LAN_ADDR_PREFIX%%LAN_ADDR_GATEWAY% metric 2 if %ITF_LAN%
route add %LAN_ADDR_OTHERS% mask 255.255.0.0 %LAN_ADDR_PREFIX%%LAN_ADDR_GATEWAY% if %ITF_LAN%
route print
goto exit
::=================================================================================
:surfWiNS
route delete 0.0.0.0
route add 0.0.0.0 mask 0.0.0.0 10.46.208.1 metric 205 if %ITF_WLAN%
10.7.32.1
:surfCMCC
route delete 0.0.0.0
route add 0.0.0.0 mask 0.0.0.0 10.7.32.1 metric 205 if %ITF_WLAN%
goto exit
:exit
echo  �������������