@echo off
echo Stopping Windows Update Service...

:: Stop the Windows Update service
net stop wuauserv

:: Disable the Windows Update service
sc config wuauserv start= disabled

echo Windows Update Service has been stopped and disabled.
pause