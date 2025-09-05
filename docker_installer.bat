@echo off
SETLOCAL EnableDelayedExpansion

echo ==========================================
echo   Docker Desktop Installation Script
echo ==========================================
echo.

:: Check if script is running as administrator
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] This installer must be run as administrator.
    echo Right-click and select "Run as administrator"
    pause
    exit /b 1
)

:: Check Windows version (Docker Desktop requires Windows 10/11)
echo Checking Windows version...
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" (
    echo Windows 10/11 detected - Compatible
) else (
    echo [ERROR] Docker Desktop requires Windows 10 or Windows 11
    pause
    exit /b 1
)

:: Check if virtualization is enabled
echo Checking virtualization support...
powershell -Command "Get-ComputerInfo | Select-Object HyperVRequirementVirtualizationFirmwareEnabled" | findstr "True" >nul
IF %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Virtualization may not be enabled in BIOS/UEFI
    echo Please enable Intel VT-x or AMD-V in your BIOS settings
    echo Continue anyway? (Y/N)
    set /p choice=
    if /i "!choice!" neq "y" exit /b 1
)

:: Check if WSL2 is installed
echo Checking WSL2 installation...
wsl --status >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo WSL2 not found. Installing WSL2...
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    
    echo Downloading WSL2 kernel update...
    powershell -Command "Invoke-WebRequest -Uri 'https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi' -OutFile 'wsl_update_x64.msi'"
    msiexec /i wsl_update_x64.msi /quiet /norestart
    del wsl_update_x64.msi
    
    wsl --set-default-version 2
    echo WSL2 installed successfully!
) ELSE (
    echo WSL2 is already installed.
)

:: Check if Docker is already installed
echo Checking if Docker Desktop is installed...
docker --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Docker Desktop is already installed.
    docker --version
    echo.
    echo Do you want to reinstall? (Y/N)
    set /p reinstall=
    if /i "!reinstall!" neq "y" goto :end
)

:: Download and install Docker Desktop
echo Downloading Docker Desktop...
set DOCKER_URL=https://desktop.docker.com/win/main/amd64/Docker%%20Desktop%%20Installer.exe
powershell -Command "try { Invoke-WebRequest -Uri '%DOCKER_URL%' -OutFile 'DockerDesktopInstaller.exe' -UserAgent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36' } catch { Write-Host 'Download failed:' $_.Exception.Message; exit 1 }"

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to download Docker Desktop installer
    echo Please check your internet connection and try again
    pause
    exit /b 1
)

echo Installing Docker Desktop...
start /wait DockerDesktopInstaller.exe install --quiet --accept-license
set INSTALL_RESULT=%ERRORLEVEL%

:: Clean up installer
del DockerDesktopInstaller.exe

IF %INSTALL_RESULT% NEQ 0 (
    echo [ERROR] Docker Desktop installation failed
    echo Please try installing manually from https://docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo Docker Desktop installed successfully!

:: Add Docker to PATH if not already there
echo Adding Docker to system PATH...
setx PATH "%PATH%;C:\Program Files\Docker\Docker\resources\bin" /M >nul 2>&1

:end
echo.
echo ==========================================
echo   Installation Complete!
echo ==========================================
echo.
echo IMPORTANT NOTES:
echo 1. A system restart may be required
echo 2. After restart, start Docker Desktop from Start Menu
echo 3. Docker Desktop may take a few minutes to start initially
echo 4. You may need to accept the Docker Desktop license agreement
echo.
echo Press any key to exit...
pause >nul
ENDLOCAL