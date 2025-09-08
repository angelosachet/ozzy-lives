@echo off
SETLOCAL

echo ==========================================
echo   Docker Compose Startup Script
echo ==========================================
echo.

:: Set the path where your docker-compose.yml is located
:: Change this path to your project directory
set PROJECT_PATH=C:\path\to\your\project

:: Check if Docker is running
echo Checking if Docker is running...
docker info >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker is not running or not installed.
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

:: Check if the project path exists
if not exist "%PROJECT_PATH%" (
    echo [ERROR] Project path does not exist: %PROJECT_PATH%
    echo Please update the PROJECT_PATH variable in this script.
    pause
    exit /b 1
)

:: Navigate to project directory
echo Navigating to project directory: %PROJECT_PATH%
cd /d "%PROJECT_PATH%"

:: Check if docker-compose.yml exists
if not exist "docker-compose.yml" (
    if not exist "docker-compose.yaml" (
        echo [ERROR] No docker-compose.yml or docker-compose.yaml found in:
        echo %PROJECT_PATH%
        pause
        exit /b 1
    )
)

:: Run docker-compose up in detached mode
echo Starting containers with docker-compose up -d...
docker-compose up -d

IF %ERRORLEVEL% EQU 0 (
    echo.
    echo ==========================================
    echo   Containers started successfully!
    echo ==========================================
    echo.
    echo Running containers:
    docker-compose ps
) ELSE (
    echo.
    echo [ERROR] Failed to start containers.
    echo Check the docker-compose.yml file and try again.
)

echo.
echo Press any key to exit...
pause >nul
ENDLOCAL