@echo off
SETLOCAL

echo ==========================================
echo   Instalador do Sistema de Filas
echo ==========================================
echo.

:: Checar se o script está sendo executado como admin
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Este instalador precisa ser executado como administrador.
    pause
    exit /b
)

:: ----- Instalar Node.js -----
echo Verificando se o Node.js esta instalado...
node -v >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Node.js nao encontrado. Baixando e instalando...
    powershell -Command "Invoke-WebRequest -Uri https://nodejs.org/dist/v18.20.4/node-v18.20.4-x64.msi -OutFile nodejs.msi"
    msiexec /i nodejs.msi /quiet /norestart
    del nodejs.msi
    echo Node.js instalado com sucesso!
) ELSE (
    echo Node.js ja esta instalado.
)

:: ----- Instalar Docker Desktop -----
echo Verificando se o Docker esta instalado...
docker -v >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Docker nao encontrado. Baixando e instalando...
    powershell -Command "Invoke-WebRequest -Uri 'https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe' -OutFile 'DockerInstaller.exe' -Headers @{ 'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)' }"
    start /wait DockerInstaller.exe install --quiet
    del DockerInstaller.exe
    echo Docker Desktop instalado com sucesso!
) ELSE (
    echo Docker ja esta instalado.
)

echo.
echo ==========================================
echo   Instalacao concluida!
echo   Reinicie o computador se necessario.
echo ==========================================
pause
ENDLOCAL
