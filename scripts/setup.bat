@echo off
REM Environment setup script for Windows
REM Creates Python virtual environment and installs dependencies

echo.
echo ============================================
echo  M5Stack AtomS3R Development Setup
echo ============================================
echo.

REM Check if Python is available
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Python is not installed or not in PATH
    echo Please install Python from https://www.python.org/
    echo.
    pause
    exit /b 1
)

REM Show Python version
echo Checking Python version...
python --version
echo.

REM Create virtual environment if it doesn't exist
if exist .venv\ (
    echo [INFO] Virtual environment already exists
) else (
    echo [INFO] Creating virtual environment...
    python -m venv .venv
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to create virtual environment
        pause
        exit /b 1
    )
    echo [OK] Virtual environment created
)
echo.

REM Activate virtual environment
echo [INFO] Activating virtual environment...
call .venv\Scripts\activate
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to activate virtual environment
    pause
    exit /b 1
)
echo [OK] Virtual environment activated
echo.

REM Upgrade pip
echo [INFO] Upgrading pip...
python -m pip install --upgrade pip --quiet
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Failed to upgrade pip, continuing anyway...
)
echo [OK] Pip upgraded
echo.

REM Install requirements
echo [INFO] Installing dependencies from requirements.txt...
pip install -r requirements.txt
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [OK] Dependencies installed
echo.

echo ============================================
echo  Setup Complete!
echo ============================================
echo.
echo The virtual environment has been created and activated.
echo.
echo IMPORTANT: Cairo/SVG Support (for images in display)
echo   If you need SVG image support, additional steps are required:
echo   1. Download GTK binaries from https://github.com/wingtk/gvsbuild/releases
echo   2. Copy cairo*.dll files from GTK bin\ to .venv\Scripts\
echo.
echo To activate the environment in the future, run:
echo   .venv\Scripts\activate
echo.
echo Common ESPHome commands:
echo   esphome config m5stack-atom-s3r.yaml     - Validate configuration
echo   esphome compile m5stack-atom-s3r.yaml    - Compile firmware
echo   esphome upload m5stack-atom-s3r.yaml     - Upload to device
echo   esphome logs m5stack-atom-s3r.yaml       - View device logs
echo.
echo Or use VS Code tasks: Ctrl+Shift+P ^> Tasks: Run Task
echo.
pause
