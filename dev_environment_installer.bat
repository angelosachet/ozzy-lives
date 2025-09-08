@echo off
SETLOCAL EnableDelayedExpansion

echo ==========================================
echo   Development Environment Installer
echo   (Docker + Essential Dev Tools)
echo ==========================================
echo.

:: Check admin privileges
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] This installer must be run as administrator.
    pause
    exit /b 1
)

echo What would you like to install?
echo 1. Docker Desktop only
echo 2. Docker + Node.js
echo 3. Docker + Node.js + Git
echo 4. Full development environment (Docker + Node.js + Git + VS Code)
echo.
set /p choice=Enter your choice (1-4): 

:: Validate choice
if "%choice%"=="1" goto :docker_only
if "%choice%"=="2" goto :docker_node
if "%choice%"=="3" goto :docker_node_git
if "%choice%"=="4" goto :full_install
echo Invalid choice. Exiting...
pause
exit /b 1

:docker_only
echo Installing Docker Desktop only...
goto :install_docker

:docker_node
echo Installing Docker Desktop and Node.js...
goto :install_docker

:docker_node_git
echo Installing Docker Desktop, Node.js, and Git...
goto :install_docker

:full_install
echo Installing full development environment...
goto :install_docker

:install_docker
echo.
echo ==========================================
echo   Installing Docker Desktop
echo ==========================================

:: Check if Docker is already installed
docker --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Docker Desktop is already installed.
    docker --version
) ELSE (
    echo Installing WSL2 prerequisites...
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    
    echo Downloading WSL2 kernel update...
    powershell -Command "Invoke-WebRequest -Uri 'https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi' -OutFile 'wsl_update.msi'"
    msiexec /i wsl_update.msi /quiet
    del wsl_update.msi
    wsl --set-default-version 2
    
    echo Downloading Docker Desktop...
    powershell -Command "Invoke-WebRequest -Uri 'https://desktop.docker.com/win/main/amd64/Docker Desktop Installer.exe' -OutFile 'DockerInstaller.exe'"
    
    echo Installing Docker Desktop...
    start /wait DockerInstaller.exe install --quiet --accept-license
    del DockerInstaller.exe
    
    echo Docker Desktop installed successfully!
)

if "%choice%"=="1" goto :installation_complete

:install_nodejs
echo.
echo ==========================================
echo   Installing Node.js
echo ==========================================



node --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Node.js is already installed.
    node --version
    npm --version
) ELSE (
    echo Downloading Node.js LTS...
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi' -OutFile 'nodejs.msi'"
    
    echo Installing Node.js...
    msiexec /i nodejs.msi /quiet /norestart
    del nodejs.msi
    
    echo Node.js installed successfully!
)

if "%choice%"=="2" goto :installation_complete

:install_git
echo.
echo ==========================================
echo   Installing Git
echo ==========================================

git --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Git is already installed.
    git --version
) ELSE (
    echo Downloading Git...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe' -OutFile 'GitInstaller.exe'"
    
    echo Installing Git...
    start /wait GitInstaller.exe /VERYSILENT /NORESTART
    del GitInstaller.exe
    
    echo Git installed successfully!
)

if "%choice%"=="3" goto :installation_complete

:install_vscode
echo.
echo ==========================================
echo   Installing Visual Studio Code
echo ==========================================

code --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Visual Studio Code is already installed.
    code --version
) ELSE (
    echo Downloading Visual Studio Code...
    powershell -Command "Invoke-WebRequest -Uri 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user' -OutFile 'VSCodeInstaller.exe'"
    
    echo Installing Visual Studio Code...
    start /wait VSCodeInstaller.exe /VERYSILENT /NORESTART /MERGETASKS=!runcode
    del VSCodeInstaller.exe
    
    echo Visual Studio Code installed successfully!
)

:installation_complete
echo.
echo ==========================================
echo   Installation Complete!
echo ==========================================
echo.
echo Installed components:
if "%choice%" geq "1" echo - Docker Desktop
if "%choice%" geq "2" echo - Node.js and npm
if "%choice%" geq "3" echo - Git
if "%choice%" geq "4" echo - Visual Studio Code
echo.
echo IMPORTANT:
echo 1. Restart your computer to complete the installation
echo 2. After restart, launch Docker Desktop from Start Menu
echo 3. Docker Desktop may take several minutes to start initially
echo 4. Configure Git with: git config --global user.name "Your Name"
echo 5. Configure Git with: git config --global user.email "your.email@example.com"
echo.
echo Press any key to exit...
pause >nul
ENDLOCAL