@echo off
echo ============================================
echo    Flutter Project Setup - Horizon UI
echo ============================================
echo.

echo Step 1: Cleaning project...
flutter clean
if %errorlevel% neq 0 (
    echo ERROR: Flutter clean failed!
    pause
    exit /b 1
)

echo.
echo Step 2: Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Dependencies failed to resolve!
    echo Trying dependency upgrade...
    flutter pub upgrade
    if %errorlevel% neq 0 (
        echo ERROR: Dependency upgrade also failed!
        echo Please check your internet connection and Flutter installation.
        pause
        exit /b 1
    )
)

echo.
echo SUCCESS: Dependencies resolved successfully!
echo.

echo Step 3: Running the app...
echo Choose your platform:
echo 1. Windows Desktop
echo 2. Web Browser
echo 3. Android (if emulator/device connected)
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    echo Running on Windows Desktop...
    flutter run -d windows
) else if "%choice%"=="2" (
    echo Running on Web Browser...
    flutter run -d web-server --web-port=8080
) else if "%choice%"=="3" (
    echo Running on Android...
    flutter run
) else (
    echo Invalid choice. Running default (Windows Desktop)...
    flutter run -d windows
)

echo.
echo App execution completed.
pause
