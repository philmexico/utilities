Rem @echo off
setlocal
cls

Rem Get admin rights
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

echo restarting wifi

Rem Restart driver
Rem netsh interface set interface name="WLAN" admin=DISABLED
Rem netsh interface set interface name="WLAN" admin=ENABLED
Rem TO TEST: nicht netshell, sondern im device manager device deaktivieren

pnputil /disable-device "PCI\VEN_14E4&DEV_4365&SUBSYS_061117AA&REV_01\00001EFFFFF99CD200"
pnputil /enable-device "PCI\VEN_14E4&DEV_4365&SUBSYS_061117AA&REV_01\00001EFFFFF99CD200"


:PROMPT
SET /P FIXED=Problem fixed (Y/[N])?
IF /I "%FIXED%" NEQ "N" GOTO END
Disable-NetAdapter -Name "WLAN" -Confirm:$false
Enable-NetAdapter -Name "WLAN" -Confirm:$false

:PROMPT
SET /P FIXED1=Problem fixed (Y/[N])?
IF /I "%FIXED1%" NEQ "N" GOTO END

Rem restart driver
echo Resetting IP
netsh winsock reset
netsh int ip reset


:PROMPT
SET /P FIXED2=Problem fixed now (Y/[N])?
IF /I "%FIXED2%" NEQ "N" GOTO END

ipconfig /release
ipconfig /renew
ipconfig /flushdns

:END
echo ending script

