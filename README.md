Telemetry Kill Script
===============
A tool for disabling Windows Telemetry (at least part of it) on Windows 
7, 8, 8.1, 10 and 11. 

Version 1.2.2

Copyright (c) 2017-2024 Davis Mosenkovs

## Introduction

There already are several instructions available for disabling Telemetry 
on Windows. 
However this is probably the first easy to use script for this purpose. 

Use of this script should be simple enough for average users and this script 
can be easily verified by IT professionals (to understand how it works and 
ensure there is nothing malicious in it).

## Usage

The script can be downloaded (after reading and accepting `LICENSE`) from 
this GitHub repository (e.g. [Releases](https://github.com/DavisNT/Telemetry-Kill-Script/releases) 
section). After downloading (and extracting) file `Telemetry-Kill-Script.cmd` it 
must be run with Administrator rights (by right clicking on it and selecting 
_Run as Administrator_).

Most likely this script will have to be used again each time when Windows Update 
updates Telemetry related files and/or service.

### Automation using Task Scheduler

To automatically run Telemetry Kill Script daily and on every system start (after reading and accepting `LICENSE`):
1. Copy the file `Telemetry-Kill-Script.cmd` to the Program Files folder (usually `C:\Program Files`).
2. Run Windows PowerShell as Administrator.
3. In the PowerShell window execute the command-line to remove Mark of the Web from `Telemetry-Kill-Script.cmd`:
```
Remove-Item -Stream "Zone.Identifier" -Path "$env:ProgramFiles\Telemetry-Kill-Script.cmd"
```
4. In the PowerShell window execute the command-line to create a scheduled task for Telemetry Kill Script:
```
Register-ScheduledTask -TaskName "Telemetry Kill Script" -User "NT AUTHORITY\SYSTEM" -RunLevel Highest -Action $(New-ScheduledTaskAction -Execute """$env:ProgramFiles\Telemetry-Kill-Script.cmd""" -Argument "/auto") -Trigger @($(New-ScheduledTaskTrigger -AtStartup), $(New-ScheduledTaskTrigger -Daily -At 19:55)) -Settings $(New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit $(New-TimeSpan -Hours 1))
```

To stop running Telemetry Kill Script automatically:
1. Delete the file `Telemetry-Kill-Script.cmd` from the Program Files folder (usually `C:\Program Files`).
2. Open Task Scheduler and delete the `Telemetry Kill Script` scheduled task.

## Notices

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
