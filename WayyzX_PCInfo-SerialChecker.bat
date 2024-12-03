@echo off
setlocal enabledelayedexpansion

:: WayyzX PC Info & Serial Checker
:: Version: 1.0.0
:: Author: Diego
:: GitHub: [Pending link]
:: Description: Comprehensive system information and diagnostic tool

title WayyzX PC Info ^& Serial Checker v1.0.0
color 0b

rem Check authentication
if not exist "%appdata%\WayyzX" mkdir "%appdata%\WayyzX"
if exist "%appdata%\WayyzX\auth.dat" goto menu

:auth
cls
echo +==============================================================================+
echo ^|                            AUTHENTICATION                                     ^|
echo +==============================================================================+
echo.
echo [*] Please enter your authentication key:
set /p "key="
if "%key%"=="KEYAUTH-WAYYZX" (
    echo %key% > "%appdata%\WayyzX\auth.dat"
    goto menu
) else (
    echo [!] Invalid key. Please try again.
    timeout /t 2 >nul
    goto auth
)

:menu
cls
echo +==============================================================================+
echo ^|                        SYSTEM INFORMATION TOOL                               ^|
echo +==============================================================================+
echo.
echo [1] System Information
echo [2] Hardware Details
echo [3] Network Information
echo [4] System Serials
echo [5] Performance Monitor
echo [6] Diagnostics (Coming Soon)
echo [7] Driver Manager (Coming Soon)
echo [8] Windows Services (Coming Soon)
echo [9] System Tools (Coming Soon)
echo [0] Exit
echo.
choice /c 1234567890 /n /m "Select an option: "
if errorlevel 10 exit
if errorlevel 9 goto tools
if errorlevel 8 goto services
if errorlevel 7 goto drivers
if errorlevel 6 goto diagnostics
if errorlevel 5 goto performance
if errorlevel 4 goto serials
if errorlevel 3 goto network
if errorlevel 2 goto hardware
if errorlevel 1 goto sysinfo

:sysinfo
cls
echo +==============================================================================+
echo ^|                        SYSTEM INFORMATION                                    ^|
echo +==============================================================================+
echo.
echo [*] OPERATING SYSTEM
echo    * Name and Version:
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
echo    * Architecture:
wmic os get osarchitecture | findstr /v /r "^$" | find /v "OSArchitecture"
echo    * Last Boot:
wmic os get lastbootuptime | findstr /v /r "^$" | find /v "LastBootUpTime"
echo    * User: %username%
echo.

echo [*] PROCESSOR
echo    * Model:
wmic cpu get name | findstr /v /r "^$" | find /v "Name"
echo    * Cores/Threads:
for /f "skip=1" %%a in ('wmic cpu get numberofcores^,numberoflogicalprocessors') do echo    Cores: %%a
echo    * Base Speed:
for /f "skip=1" %%a in ('wmic cpu get maxclockspeed') do echo    %%a MHz
echo.

echo [*] MEMORY
echo    * Physical Memory:
systeminfo | findstr /C:"Total Physical Memory" /C:"Available Physical Memory"
echo    * Virtual Memory:
systeminfo | findstr /C:"Total Virtual Memory" /C:"Available Virtual Memory"
echo    * Page File:
systeminfo | findstr /C:"Page File Location" /C:"Page File Space"
echo.

echo [*] MOTHERBOARD
echo    * Manufacturer and Model:
for /f "skip=1 tokens=*" %%a in ('wmic baseboard get manufacturer') do echo    Manufacturer: %%a
for /f "skip=1 tokens=*" %%a in ('wmic baseboard get product') do echo    Model: %%a
echo    * BIOS:
for /f "skip=1 tokens=*" %%a in ('wmic bios get manufacturer^,version') do echo    %%a
echo.

echo [*] STORAGE
echo    * Drives:
for /f "skip=1" %%a in ('wmic logicaldisk get caption^,description^,filesystem^,size^,freespace') do (
    set "line=%%a"
    setlocal enabledelayedexpansion
    echo    !line!
    endlocal
)
echo.

choice /c SRX /n /m "Press [S] to save, [R] to refresh or [X] to return: "
if errorlevel 3 goto menu
if errorlevel 2 goto sysinfo
if errorlevel 1 goto save

:hardware
cls
echo +==============================================================================+
echo ^|                        HARDWARE DETAILS                                      ^|
echo +==============================================================================+
echo.
echo [*] GRAPHICS CARD
echo    * Model:
for /f "skip=1 tokens=*" %%a in ('wmic path win32_videocontroller get caption') do echo    %%a
echo    * Memory:
for /f "skip=1" %%a in ('wmic path win32_videocontroller get adapterram') do set /a vram=%%a/1024/1024 & echo    %%a MB
echo    * Resolution:
for /f "skip=1 tokens=*" %%a in ('wmic path win32_videocontroller get currenthorizontalresolution^,currentverticalresolution^,currentrefreshrate') do echo    %%a
echo    * Driver:
for /f "skip=1 tokens=*" %%a in ('wmic path win32_videocontroller get driverversion') do echo    %%a
echo.

echo [*] STORAGE
echo    * Physical Drives:
for /f "skip=1 tokens=*" %%a in ('wmic diskdrive get caption^,size') do echo    %%a
echo    * Status:
for /f "skip=1 tokens=*" %%a in ('wmic diskdrive get status') do echo    %%a
echo.

echo [*] MEMORY
echo    * Slots:
for /f "skip=1 tokens=*" %%a in ('wmic memorychip get capacity^,speed^,manufacturer') do echo    %%a
echo    * Type:
for /f "skip=1 tokens=*" %%a in ('wmic memorychip get memorytype^,formfactor') do echo    %%a
echo.

echo [*] SOUND CARD
echo    * Devices:
for /f "skip=1 tokens=*" %%a in ('wmic sounddev get caption') do echo    %%a
echo.

echo [*] USB
echo    * Controllers:
for /f "skip=1 tokens=*" %%a in ('wmic usbcontroller get caption') do echo    %%a
echo    * Devices:
for /f "skip=1 tokens=*" %%a in ('wmic usbhub get caption') do echo    %%a
echo.

choice /c SRX /n /m "Press [S] to save, [R] to refresh or [X] to return: "
if errorlevel 3 goto menu
if errorlevel 2 goto hardware
if errorlevel 1 goto save

:network
cls
echo +==============================================================================+
echo ^|                        NETWORK INFORMATION                                  ^|
echo +==============================================================================+
echo.
echo [*] ADAPTERS
echo    * Interfaces:
for /f "skip=1 tokens=*" %%a in ('wmic nic where "PhysicalAdapter=True" get caption^,macaddress') do echo    %%a
echo.

echo [*] IP CONFIGURATION
echo    * IPv4:
for /f "tokens=*" %%a in ('ipconfig ^| findstr /C:"IPv4" /C:"Subnet Mask" /C:"Default Gateway"') do echo    %%a
echo    * DNS:
for /f "tokens=*" %%a in ('ipconfig /all ^| findstr /C:"DNS Servers"') do echo    %%a
echo.

echo [*] PUBLIC IP
echo    * Address:
for /f %%a in ('curl -s ifconfig.me') do echo    %%a
echo.

echo [*] CONNECTIONS
echo    * Active:
for /f "tokens=*" %%a in ('netstat -an ^| findstr "ESTABLISHED"') do echo    %%a
echo.

echo [*] PING
echo    * Local (127.0.0.1):
for /f "tokens=*" %%a in ('ping 127.0.0.1 -n 1 ^| findstr "ms"') do echo    %%a
echo    * Google DNS (8.8.8.8):
for /f "tokens=*" %%a in ('ping 8.8.8.8 -n 1 ^| findstr "ms"') do echo    %%a
echo.

choice /c SRX /n /m "Press [S] to save, [R] to refresh or [X] to return: "
if errorlevel 3 goto menu
if errorlevel 2 goto network
if errorlevel 1 goto save

:serials
cls
echo +==============================================================================+
echo ^|                        SYSTEM SERIALS                                       ^|
echo +==============================================================================+
echo.
echo [*] SYSTEM
echo  ▸ Windows Product ID:
wmic os get serialnumber | findstr /v /r "^$"
echo  ▸ UUID:
wmic csproduct get uuid | findstr /v /r "^$"
echo.

echo [*] HARDWARE
echo  ▸ BIOS:
wmic bios get serialnumber | findstr /v /r "^$"
echo  ▸ Motherboard:
wmic baseboard get serialnumber | findstr /v /r "^$"
echo  ▸ CPU:
wmic cpu get processorid | findstr /v /r "^$"
echo  ▸ HD/SSD:
wmic diskdrive get serialnumber | findstr /v /r "^$"
echo.

echo [*] NETWORK
echo  ▸ MAC Address:
getmac /v | findstr "Physical"
echo.

echo [*] VOLUME
echo  ▸ Serial Number:
vol c:
echo.

choice /c SRX /n /m "Press [S] to save, [R] to refresh or [X] to return: "
if errorlevel 3 goto menu
if errorlevel 2 goto serials
if errorlevel 1 goto save

:performance
cls
echo +==============================================================================+
echo ^|                        PERFORMANCE MONITOR                                  ^|
echo +==============================================================================+
echo.
echo [*] CPU
echo  ▸ Current Usage:
wmic cpu get loadpercentage | findstr /v /r "^$"
echo  ▸ Processes:
tasklist /fi "memusage gt 10000" | sort /r
echo.

echo [*] MEMORY
echo  ▸ In Use:
wmic os get freephysicalmemory,totalvisiblememorysize | findstr /v /r "^$"
echo  ▸ Top Consumers:
tasklist /fi "memusage gt 50000" | sort /r
echo.

echo [*] DISK
echo  ▸ Free Space:
wmic logicaldisk get caption,freespace,size | findstr /v /r "^$"
echo  ▸ Current IO:
wmic process where "ReadOperationCount > 0" get caption,readoperationcount,writeoperationcount | findstr /v /r "^$"
echo.

echo [*] NETWORK
echo  ▸ Connections:
netstat -n | find "ESTABLISHED" /c
echo  ▸ Bandwidth:
netstat -e
echo.

choice /c SRX /n /m "Press [S] to save, [R] to refresh or [X] to return: "
if errorlevel 3 goto menu
if errorlevel 2 goto performance
if errorlevel 1 goto save

:diagnostics
cls
echo +==============================================================================+
echo ^|                        DIAGNOSTICS (COMING SOON)                            ^|
echo +==============================================================================+
echo.
echo     Next update will include:
echo     - System integrity check
echo     - Virus and malware scan
echo     - System log analysis
echo     - Driver verification
echo     - Performance tests
echo.
pause
goto menu

:drivers
cls
echo +==============================================================================+
echo ^|                        DRIVER MANAGER (COMING SOON)                          ^|
echo +==============================================================================+
echo.
echo     Next update will include:
echo     - List of all drivers
echo     - Update status
echo     - Driver backup
echo     - Driver restore
echo     - Compatibility check
echo.
pause
goto menu

:services
cls
echo +==============================================================================+
echo ^|                        WINDOWS SERVICES (COMING SOON)                        ^|
echo +==============================================================================+
echo.
echo     Next update will include:
echo     - Service management
echo     - System optimization
echo     - Startup configuration
echo     - Service analysis
echo     - Optimization profiles
echo.
pause
goto menu

:tools
cls
echo +==============================================================================+
echo ^|                        SYSTEM TOOLS (COMING SOON)                           ^|
echo +==============================================================================+
echo.
echo     Next update will include:
echo     - System cleanup
echo     - Backup and restore
echo     - Registry tools
echo     - Security analysis
echo     - Advanced optimization
echo.
pause
goto menu

:save
cls
echo +==============================================================================+
echo ^|                             SAVING INFORMATION                              ^|
echo +==============================================================================+
echo.
set "report_file=%userprofile%\Desktop\WayyzX_Report_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%.txt"
echo Generating report in: %report_file%
echo.
echo +==============================================================================+ > "%report_file%"
echo ^|                        SYSTEM INFORMATION TOOL                               ^| >> "%report_file%"
echo +==============================================================================+ >> "%report_file%"
echo. >> "%report_file%"
echo Date: %date% >> "%report_file%"
echo Time: %time% >> "%report_file%"
echo. >> "%report_file%"

echo [*] OPERATING SYSTEM >> "%report_file%"
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" >> "%report_file%"
echo. >> "%report_file%"

echo [*] PROCESSOR >> "%report_file%"
wmic cpu get name,numberofcores,numberoflogicalprocessors /format:list >> "%report_file%"
echo. >> "%report_file%"

echo [*] MEMORY >> "%report_file%"
systeminfo | findstr /C:"Total Physical Memory" /C:"Available Physical Memory" >> "%report_file%"
echo. >> "%report_file%"

echo [*] GRAPHICS CARD >> "%report_file%"
wmic path win32_videocontroller get caption,driverversion /format:list >> "%report_file%"
echo. >> "%report_file%"

echo [*] STORAGE >> "%report_file%"
wmic diskdrive get caption,size,status /format:list >> "%report_file%"
echo. >> "%report_file%"

echo [*] NETWORK >> "%report_file%"
ipconfig /all >> "%report_file%"
echo. >> "%report_file%"

echo [*] SERIALS >> "%report_file%"
echo UUID: >> "%report_file%"
wmic csproduct get uuid >> "%report_file%"
echo BIOS: >> "%report_file%"
wmic bios get serialnumber >> "%report_file%"
echo. >> "%report_file%"

echo Report generated successfully!
echo.
echo Press any key to return to menu...
pause >nul
goto menu
