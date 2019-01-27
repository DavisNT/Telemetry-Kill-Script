@echo off
rem Display info and license
color f0
echo Telemetry Kill Script 1.1.0
echo A tool for disabling Windows Telemetry (at least part of it).
echo https://github.com/DavisNT/Telemetry-Kill-Script
echo.
echo Copyright (c) 2017-2019 Davis Mosenkovs
echo.
echo Permission is hereby granted, free of charge, to any person obtaining a copy
echo of this software and associated documentation files (the "Software"), to deal
echo in the Software without restriction, including without limitation the rights
echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
echo copies of the Software, and to permit persons to whom the Software is
echo furnished to do so, subject to the following conditions:
echo.
echo The above copyright notice and this permission notice shall be included in all
echo copies or substantial portions of the Software.
echo.
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
echo OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
echo SOFTWARE.
echo.
verify other 2>nul
setlocal enableextensions
if errorlevel 1 goto :end
set accepted=
if not "%1"=="/AUTO" if not "%1"=="/auto" set /P accepted=Press enter if you agree or immediately close this window otherwise! 
if not "%accepted%"=="" goto :end
echo.

rem Check 64-bit environment on 64-bit Windows
if not "%PROCESSOR_ARCHITEW6432%"=="" goto :wow

rem Check admin rights
net session >nul 2>nul
if errorlevel 1 goto :noadmin

rem Disable Telemetry
set errors=0
echo Taking ownership of Telemetry files...
takeown /A /F %SystemRoot%\system32\CompatTelRunner.exe
if errorlevel 1 set errors=1
takeown /A /F %SystemRoot%\system32\GeneralTel.dll
if errorlevel 1 set errors=1
echo.
echo Changing permissions of Telemetry files...
icacls %SystemRoot%\system32\CompatTelRunner.exe /deny *S-1-1-0:(X)
if errorlevel 1 set errors=1
icacls %SystemRoot%\system32\GeneralTel.dll /deny *S-1-1-0:(X)
if errorlevel 1 set errors=1
echo.
echo Setting diagnostic data level to Security/Basic (lowest possible)...
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
if errorlevel 1 set errors=1
echo.
echo Disabling Telemetry service...
sc config DiagTrack start= disabled
if errorlevel 1 set errors=1
echo.
echo Terminating Telemetry processes...
taskkill /f /im CompatTelRunner*
taskkill /f /im rundll32* /fi "MODULES eq GeneralTel*"
echo.
echo Stopping Telemetry service...
net stop DiagTrack 2>nul
echo.

rem Display results
if "%errors%"=="1" goto :errors

rem Success
color f2
echo Telemetry should be disabled now.
echo You might need to reboot your computer for some of the changes to take effect.
if not "%1"=="/AUTO" if not "%1"=="/auto" pause

goto :end

rem Errors occurred
:errors
color fc
echo Error(s) occurred, please review the script output!
if not "%1"=="/AUTO" if not "%1"=="/auto" pause

goto :end

rem 32-bit environment on 64-bit Windows error
:wow
color fc
echo This script must NOT be run from 32-bit environment on 64-bit Windows.
echo Please run this script from 64-bit application (e.g. File Explorer window).
if not "%1"=="/AUTO" if not "%1"=="/auto" pause

goto :end

rem Missing admin rights error
:noadmin
color fc
echo This script must be run with Administrator rights.
echo Please right click on the script and select "Run as Administrator"
if not "%1"=="/AUTO" if not "%1"=="/auto" pause

rem For compatibility
:end
