::������ʱ���������
::schtasks /create /sc minute /mo 2 /tn "auth" /tr c:\auth.bat
@echo off
cd c:\
::��仰���ڶ�ʱ������
SET T=%date:~2,8% %time:~0,2%:%time:~3,2%:%time:~6,2%

setlocal enabledelayedexpansion
::��֤����ж�
::delims=�� ��ʾ��ȡһ�� ^����ת�� ����302������wget���Ա�׼����ķ�ʽ����ģ�������Ҫ�ض���
for /f "usebackq tokens=1,* delims=" %%i in (`wget.exe -S --max-redirect 0 http://qq.com 2^>^&1^|find "[following]"`) do (
::for /f "usebackq tokens=1,* delims=." %%i in (`route print^|find "VMware"`) do (
    set WGET_RET=%%i
    echo !WGET_RET!
)
::�˴���endlocal�����ⲿ���Ҳ���WGET_RET������
::endlocal
::����д������
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


::-O -�������԰�html������ն� 
::wget -q -O - http://www.baidu.com
::����ֱ�����ùܵ��Ĳ���
:: wget.exe -S --max-redirect 0 http://qq.com || echo success.
:: wget.exe -S --max-redirect 0 http://qq.coma || echo failed.
:: wget.exe -S --max-redirect 0 http://qq.com || echo success.