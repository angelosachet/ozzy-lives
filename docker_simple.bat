@echo off
SETLOCAL

echo ==========================================
echo   Simple Docker Desktop Installer
echo ==========================================
echo.

:: Check admin privileges
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Run as administrator required
    pause
    exit /b 1
)

:: Check if Docker is installed
echo Checking Docker installation...
docker --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Docker is already installed:
    docker --version
    pause
    exit /b 0
)

:: Install WSL2 (required for Docker Desktop)
echo Installing WSL2...
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

:: Download WSL2 kernel update
echo Downloading WSL2 kernel update...
powershell -Command "Invoke-WebRequest -Uri 'https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi' -OutFile 'wsl_update.msi'"
msiexec /i wsl_update.msi /quiet
del wsl_update.msi
wsl --set-default-version 2

:: Download and install Docker Desktop
echo Downloading Docker Desktop...
powershell -Command "Invoke-WebRequest -Uri 'https://desktop.docker.com/win/main/amd64/Docker Desktop Installer.exe' -OutFile 'DockerInstaller.exe'"

echo Installing Docker Desktop...
start /wait DockerInstaller.exe install --quiet --accept-license
del DockerInstaller.exe

echo.
echo ==========================================
echo   Docker Desktop Installation Complete!
echo ==========================================
echo.
echo Please restart your computer to complete the installation.
echo After restart, launch Docker Desktop from the Start Menu.
echo.
pause
ENDLOCAL