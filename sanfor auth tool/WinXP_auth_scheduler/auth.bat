::创建定时任务的命令
::schtasks /create /sc minute /mo 2 /tn "auth" /tr c:\auth.bat
@echo off
cd c:\
::这句话用于定时任务里
SET T=%date:~2,8% %time:~0,2%:%time:~3,2%:%time:~6,2%

setlocal enabledelayedexpansion
::认证结果判断
::delims=空 表示获取一行 ^用于转义 若是302，对于wget是以标准错误的方式输出的，所以需要重定向
for /f "usebackq tokens=1,* delims=" %%i in (`wget.exe -S --max-redirect 0 http://qq.com 2^>^&1^|find "[following]"`) do (
::for /f "usebackq tokens=1,* delims=." %%i in (`route print^|find "VMware"`) do (
    set WGET_RET=%%i
    echo !WGET_RET!
)
::此处若endlocal，到外部就找不到WGET_RET变量了
::endlocal
::两种写法均可
::if "%WGET_RET!%=="Location: http://www.qq.com/ [following]" (echo OK) else echo NO
if "!WGET_RET!"=="Location: http://www.qq.com/ [following]" (goto CHECK_OK) else goto CHECK_FAILED

:CHECK_OK
echo %T% internet check is ok
echo %T% internet check is ok >> auth.log
goto END
:CHECK_FAILED
echo internet check failed, begin auth.
echo %T% internet check failed >> auth.log
::"python.exe" "c:\auth.py" && echo %T% auth success >> auth.log || echo %T% auth failed >> auth.log && (exit /b -1)
"python.exe" "auth.py" && echo %T% auth success >> auth.log || echo %T% auth failed >> auth.log && goto END

goto END

:END
::set "str=  Location: http://www.qq.com/"
::if "!str!"=="  Location: http://www.qq.com/" (echo OK) else echo CHECK_FAILED
::echo "!WGET_RET!"
::if "!WGET_RET!"=="Location: http://www.qq.com/ [following]" (echo OK) else echo CHECK_FAILED


::-O -这样可以把html输出到终端 
::wget -q -O - http://www.baidu.com
::这样直接利用管道的不行
:: wget.exe -S --max-redirect 0 http://qq.com || echo success.
:: wget.exe -S --max-redirect 0 http://qq.coma || echo failed.
:: wget.exe -S --max-redirect 0 http://qq.com || echo success.