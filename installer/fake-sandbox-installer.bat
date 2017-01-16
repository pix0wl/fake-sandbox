@echo off
:start
::   *-----------------------------------------------------------------------------*
::   | This file is writing my optimized version of the FS.ps1 script to |
::   | your autostart directory. After you log in to your user account this script |
::   | will launch automatically and start as ususal.                              |
::   |                                                                             |
::   | Like the original file, the startup script will simulate fake processes of  |
::   | analysis sandbox/VM software some malware will try to evad                  |
::   | This just spawn ping.exe with different names (wireshark.exe, vboxtray.exe, |
::   | etc...)                                                                     |
::   *-----------------------------------------------------------------------------*--------*                                                           
::   | Hint: This is only for your user account. It will open at Startup and there is no    |
::   | way to stop the processes but to download the full file and execute the stop action. |
::   *--------------------------------------------------------------------------------------*
::   |P.S: I know this is not the most elegant implementation, but hey... it works.         | 
::   *--------------------------------------------------------------------------------------*

::  Please enter your desired fake processes here:
SET @proc="WinDbg.exe","idaq.exe","wireshark.exe","vmacthlp.exe","VBoxService.exe","VBoxTray.exe","procmon.exe","pexplorer.exe","ollydbg.exe","vmware-tray.exe","idag.exe","ImmunityDebugger.exe"

:: -------------------------------------------------------------------------------------------------------------------------------
:: Title and Version code
TITLE FS Installer
COLOR 0F
SET @v=1.6
SET path=%~dp0
:: -------------------------------------------------------------------------------------------------------------------------------
:: Just some nice user interface things
cls
echo You are about to install the FS script to your computer (autostart).
SET /P ANSWER=Would you like to continue? (y/n): 

if /i %ANSWER%==y (goto install)
if /i %ANSWER%==n (goto no)
goto unrecog

:: -------------------------------------------------------------------------------------------------------------------------------
:: Creation of the fs.ps1 script in the new directory %appdata%\FS\
:install
del "%appdata%\FS\FS.ps1"
if not exist %appdata%\FS\ (md "%appdata%\FS\")

echo.>>"%appdata%\FS\FS.ps1"
echo $fakeProcesses = @(%@proc%)>>"%appdata%\FS\FS.ps1"
echo.>>"%appdata%\FS\FS.ps1"
echo     $tmpdir = [System.Guid]::NewGuid().ToString()>>"%appdata%\FS\FS.ps1"
echo     $binloc = Join-path $env:temp $tmpdir>>"%appdata%\FS\FS.ps1"
echo.>>"%appdata%\FS\FS.ps1"
echo     New-Item -Type Directory -Path $binloc>>"%appdata%\FS\FS.ps1"
echo     $oldpwd = $pwd>>"%appdata%\FS\FS.ps1"
echo     Set-Location $binloc>>"%appdata%\FS\FS.ps1"
echo.>>"%appdata%\FS\FS.ps1"
echo     foreach ($proc in $fakeProcesses) {>>"%appdata%\FS\FS.ps1"
echo       Copy-Item c:\windows\system32\ping.exe "$binloc\$proc">>"%appdata%\FS\FS.ps1"
echo.>>"%appdata%\FS\FS.ps1"
echo       Start-Process ".\$proc" -WindowStyle Hidden -ArgumentList "-t -w 3600000 -4 1.1.1.1">>"%appdata%\FS\FS.ps1"
echo       write-host "[+] Process $proc spawned">>"%appdata%\FS\FS.ps1"
echo      }>>"%appdata%\FS\FS.ps1"
echo.>>"%appdata%\FS\FS.ps1"
echo     Set-Location $oldpwd>>"%appdata%\FS\FS.ps1"

:: -------------------------------------------------------------------------------------------------------------------------------
:: Creation of the file that will execute the Powershell script upon startup
del "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\FS.bat"

echo @echo off>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\FS.bat"
echo TITLE FS is starting...>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\FS.bat"
echo.>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\FS.bat"
echo.>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\FS.bat"
echo echo Starting main script....>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\FS.bat"
echo start /MIN powershell -executionpolicy remotesigned -WindowStyle Hidden -File "C:\Users\%USERNAME%\AppData\Roaming\FS\FS.ps1">>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\FS.bat"
echo.>>"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\FS.bat"

:: -------------------------------------------------------------------------------------------------------------------------------
:: End of file installation
:: <---- delete this line and add "pause" instead to enable debugging.
:: -------------------------------------------------------------------------------------------------------------------------------
:: Look for any error:
:done
if errorlevel 1 goto error
COLOR 0A
cls
echo.
echo Done, all files have been created. This should work after you relogin. Please press any key to exit...
echo.  
pause > NUL
exit

:: If there was an error, the following commands will be used:
:error
COLOR 0C
cls
echo.
echo An error occured!
echo If you already had a previous version installed and tried to update it, ignore this error - everything went fine. 
echo If this is your first installation, please try it again or enable debugging in this script.
echo.
echo The file can be found here:
echo %path:~0,-1%
echo.
echo Press any key to exit...
echo.  
pause > NUL
exit

:: -------------------------------------------------------------------------------------------------------------------------------
:: If you chose not to install this will execute:
:no
cls
echo.
echo You chose not to install FS processes. Press any key to exit...
echo.
pause > NUL
exit

:: If you did not choose "n" nor "y" this will appear:
:unrecog
COLOR 0C
cls
echo.
echo An error occured!
echo Unrecognized command. You have to choose "y" for yes and "n" for no.
echo.
echo Press any key to restart...
echo.
pause > NUL
goto start
