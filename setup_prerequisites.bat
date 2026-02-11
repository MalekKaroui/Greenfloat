@echo off
cls
echo ================================================================
echo     GreenFloat - Automatic Prerequisites Installer
echo ================================================================
echo.
echo This script will install:
echo   1. Icarus Verilog (if not installed)
echo   2. Python packages (numpy, matplotlib, pandas)
echo.
echo Press Ctrl+C to cancel, or
pause
echo.

REM ================================================================
REM Check if running as Administrator
REM ================================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [WARNING] Not running as Administrator
    echo Some installations may require administrator privileges.
    echo.
    pause
)

REM ================================================================
REM Step 1: Check Python
REM ================================================================
echo.
echo [1/3] Checking Python installation...
echo ----------------------------------------------------------------

python --version >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Python not found!
    echo.
    echo Please install Python manually:
    echo   1. Go to: https://www.python.org/downloads/
    echo   2. Download Python 3.x
    echo   3. IMPORTANT: Check "Add Python to PATH" during installation
    echo   4. Run this script again after installation
    echo.
    pause
    exit /b 1
) else (
    python --version
    echo [OK] Python is installed
)

REM ================================================================
REM Step 2: Install Python Packages
REM ================================================================
echo.
echo [2/3] Installing Python packages...
echo ----------------------------------------------------------------

echo Installing numpy...
pip install numpy --quiet --upgrade
if errorlevel 1 (
    echo [WARN] numpy installation had issues, but continuing...
) else (
    echo [OK] numpy installed
)

echo Installing matplotlib...
pip install matplotlib --quiet --upgrade
if errorlevel 1 (
    echo [WARN] matplotlib installation had issues, but continuing...
) else (
    echo [OK] matplotlib installed
)

echo Installing pandas...
pip install pandas --quiet --upgrade
if errorlevel 1 (
    echo [WARN] pandas installation had issues, but continuing...
) else (
    echo [OK] pandas installed
)

REM ================================================================
REM Step 3: Check Icarus Verilog
REM ================================================================
echo.
echo [3/3] Checking Icarus Verilog...
echo ----------------------------------------------------------------

iverilog -V >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Icarus Verilog not found!
    echo.
    echo Attempting to download installer...
    echo.
    
    REM Download Icarus Verilog installer
    set IVERILOG_URL=https://bleyer.org/icarus/iverilog-v12-20220611-x64_setup.exe
    set INSTALLER=iverilog_installer.exe
    
    echo Downloading from: %IVERILOG_URL%
    
    REM Use PowerShell to download
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%IVERILOG_URL%' -OutFile '%INSTALLER%'}"
    
    if exist %INSTALLER% (
        echo [OK] Download complete!
        echo.
        echo Starting installer...
        echo Please follow the installation wizard.
        echo IMPORTANT: Use default installation path!
        echo.
        start /wait %INSTALLER%
        
        echo.
        echo Cleaning up installer...
        del %INSTALLER%
        
        echo.
        echo Testing Icarus Verilog installation...
        iverilog -V >nul 2>&1
        if errorlevel 1 (
            echo [WARN] Icarus Verilog may not be in PATH
            echo Please restart your computer and try again.
        ) else (
            echo [OK] Icarus Verilog installed successfully!
        )
    ) else (
        echo [FAIL] Download failed!
        echo.
        echo Please install manually:
        echo   1. Go to: http://bleyer.org/icarus/
        echo   2. Download: iverilog-v12-20220611-x64_setup.exe
        echo   3. Run the installer
        echo   4. Restart your computer
        echo.
    )
) else (
    iverilog -V | findstr "version"
    echo [OK] Icarus Verilog is installed
)

REM ================================================================
REM Final Verification
REM ================================================================
echo.
echo ================================================================
echo                 Installation Summary
echo ================================================================
echo.

python --version >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Python: NOT FOUND
    set /a ERRORS+=1
) else (
    python --version
    echo [OK] Python: INSTALLED
)

python -c "import numpy" >nul 2>&1
if errorlevel 1 (
    echo [FAIL] numpy: NOT INSTALLED
    set /a ERRORS+=1
) else (
    python -c "import numpy; print('[OK] numpy:', numpy.__version__)"
)

python -c "import matplotlib" >nul 2>&1
if errorlevel 1 (
    echo [FAIL] matplotlib: NOT INSTALLED
    set /a ERRORS+=1
) else (
    python -c "import matplotlib; print('[OK] matplotlib:', matplotlib.__version__)"
)

python -c "import pandas" >nul 2>&1
if errorlevel 1 (
    echo [FAIL] pandas: NOT INSTALLED
    set /a ERRORS+=1
) else (
    python -c "import pandas; print('[OK] pandas:', pandas.__version__)"
)

iverilog -V >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Icarus Verilog: NOT FOUND
    set /a ERRORS+=1
) else (
    echo [OK] Icarus Verilog: INSTALLED
)

echo.
echo ================================================================

if "%ERRORS%"=="" (
    echo.
    echo [SUCCESS] All prerequisites are installed!
    echo.
    echo You can now run the project:
    echo   build.bat
    echo.
) else (
    echo.
    echo [WARNING] Some prerequisites are missing.
    echo Please install them manually and run this script again.
    echo.
)

echo ================================================================
echo.
pause