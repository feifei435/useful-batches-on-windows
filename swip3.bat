@echo off
rem color 2a
rem mode con cols=50 lines=20

::==================================获取网卡接口号=================================
setlocal enabledelayedexpansion
::寻找有线网卡
for /f "usebackq tokens=1,* delims=." %%i in (`route print^|find "Realtek PCIe GBE Family Controller"`) do (
set ITF_LAN=%%i
rem echo !ITF_LAN!
)
::去除网卡号左边空格
:intercept1
if "%ITF_LAN:~0,1%"==" " set "ITF_LAN=%ITF_LAN:~1%" && goto intercept1
rem

::寻找无线网卡
for /f "usebackq tokens=1,* delims=." %%i in (`route print^|find "Broadcom 802.11n 网络适配器"`) do (
set ITF_WLAN=%%i
rem echo !ITF_WLAN!
)
::去除网卡号左边空格
:intercept2
if "%ITF_WLAN:~0,1%"==" " set "ITF_WLAN=%ITF_WLAN:~1%" && goto intercept2
rem echo 无线网卡接口号：%ITF_WLAN%

::寻找虚拟机网卡
for /f "usebackq tokens=1,* delims=." %%i in (`route print^|find "VMnet2"`) do (
set ITF_VM=%%i
echo !ITF_VM!
)
::去除网卡号左边空格
:intercept2
if "%ITF_WLAN:~0,1%"==" " set "ITF_WLAN=%ITF_WLAN:~1%" && goto intercept2
rem echo 无线网卡接口号：%ITF_WLAN%

::本机有线IP信息，用户可编辑
set "LAN_ADDR_PREFIX=192.168.50."
set "LAN_ADDR_OTHERS=192.168.0.0"
set "LAN_ADDR_SUFFIX=175"
set "LAN_ADDR_GATEWAY=254"
set "LAN_ADDR_DNS1=223.5.5.5"
set "LAN_ADDR_DNS2=223.6.6.6"
::本机无线IP信息，用户可编辑
set "WLAN_ADDR_PREFIX=27.39.37."
set "WLAN_ADDR_SUFFIX=41"
::代理虚拟机IP信息
set "VIRTUAL_MACHINE_IP=10.10.10.15"
rem set "WLAN_ADDR_SUFFIX=74"
set "WLAN_ADDR_GATEWAY=1"
set "WLAN_ADDR_DNS1=210.21.196.6"
set "WLAN_ADDR_DNS2=221.5.88.88"
::=================================================================================

echo 1 切换无线网络连接为金证6层联通热点IP:%WLAN_ADDR_PREFIX%%WLAN_ADDR_SUFFIX%
echo 2 切换无线网络连接为DHCP
echo 3 切换有线网络为%LAN_ADDR_PREFIX%%LAN_ADDR_SUFFIX%
echo 4 切换有线网络连接为DHCP
echo 5 使用内网上网
echo 6 使用CMCC-WiNS上网
echo 7 使用CMCC上网
echo 8 仅添加内网路由(同时使用虚拟机路由上网)
set /p select=请输入选择
if /i "%select%" == "1" goto WLAN_UNICOM
if /i "%select%" == "2" goto WLAN_DHCP
if /i "%select%" == "3" goto LANIP
if /i "%select%" == "4" goto LAN_DHCP
if /i "%select%" == "5" goto surfLAN
if /i "%select%" == "6" goto surfWiNS
if /i "%select%" == "7" goto surfCMCC
if /i "%select%" == "8" goto add_LAN_route

:WLAN_UNICOM
rem netsh interface ip set address name="无线网络连接" source=static addr=27.39.37.74 mask=255.255.255.0 gateway=27.39.37.1 gwmetric=0
rem netsh interface ip set dns name="无线网络连接" source=static addr=210.21.196.6 register=primary
rem netsh interface ip add dns name="无线网络连接" addr=221.5.88.88
netsh interface ip set address name="无线网络连接" source=static addr=27.39.37.41 mask=255.255.255.0 gateway=%WLAN_ADDR_PREFIX%%WLAN_ADDR_GATEWAY% gwmetric=0
netsh interface ip set dns name="无线网络连接" source=static addr=%WLAN_ADDR_DNS1% register=primary
netsh interface ip add dns name="无线网络连接" addr=%WLAN_ADDR_DNS2%
route delete 0.0.0.0
route add 0.0.0.0 mask 0.0.0.0 %WLAN_ADDR_GATEWAY% metric 205 if %ITF_WLAN%

goto exit
:WLAN_DHCP
netsh interface ip set address "无线网络连接" DHCP
netsh interface ip set dns "无线网络连接" DHCP
:LANIP
netsh interface ip set address name="本地连接" source=static addr=%LAN_ADDR_PREFIX%%LAN_ADDR_SUFFIX% mask=255.255.255.0 gateway=%LAN_ADDR_PREFIX%%LAN_ADDR_GATEWAY% gwmetric=0
netsh interface ip set dns name="本地连接" source=static addr=%LAN_ADDR_DNS1% register=primary
netsh interface ip add dns name="本地连接" addr=%LAN_ADDR_DNS2%
ping 127.0.0.1 > nul
goto exit
:LAN_DHCP
netsh interface ip set address "本地连接" DHCP
netsh interface ip set dns "本地连接" DHCP
goto exit
::=================================================================================
:add_LAN_route
echo 请确认以下信息(若不符请手动编辑bat修改)：
echo 有线网卡接口号：%ITF_LAN%
echo 无线网卡接口号：%ITF_WLAN%
echo 本机网段:%LAN_ADDR_PREFIX%0
echo 有线网卡IP:%LAN_ADDR_PREFIX%%LAN_ADDR_SUFFIX%
set /p confirm=(y/n)?
if /i "%confirm%" == "y" goto add_LAN_route_true
echo  未做任何更改
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
echo 请确认以下信息(若不符请手动编辑bat修改)：
echo 有线网卡接口号：%ITF_LAN%
echo 无线网卡接口号：%ITF_WLAN%
echo 本机网段:%LAN_ADDR_PREFIX%0
echo 有线网卡IP:%LAN_ADDR_PREFIX%%LAN_ADDR_SUFFIX%
set /p confirm=(y/n)?
if /i "%confirm%" == "y" goto surfLANtrue
echo  未做任何更改
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
echo  批处理设置完成