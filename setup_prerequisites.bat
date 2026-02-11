@echo off
cls
echo ================================================================
echo     GreenFloat - Prerequisites Installer
echo ================================================================
echo.

REM Check Python
echo Checking Python...
python --version
if errorlevel 1 (
    echo.
    echo ERROR: Python not found!
    echo Install from: https://www.python.org/downloads/
    pause
    exit /b 1
)
echo OK - Python found
echo.

REM Install packages one by one
echo Installing Python packages (this may take a minute)...
echo.

echo [1/3] Installing numpy...
python -m pip install --upgrade pip >nul 2>&1
python -m pip install numpy
echo.

echo [2/3] Installing matplotlib...
python -m pip install matplotlib
echo.

echo [3/3] Installing pandas...
python -m pip install pandas
echo.

echo ================================================================
echo Checking installations...
echo ================================================================
echo.

python -c "import numpy; print('OK - numpy version:', numpy.__version__)"
python -c "import matplotlib; print('OK - matplotlib version:', matplotlib.__version__)"
python -c "import pandas; print('OK - pandas version:', pandas.__version__)"

echo.
echo ================================================================
echo Checking Icarus Verilog...
echo ================================================================
echo.

iverilog -V >nul 2>&1
if errorlevel 1 (
    echo NOT FOUND - Icarus Verilog needs manual installation
    echo.
    echo Steps:
    echo   1. Go to: http://bleyer.org/icarus/
    echo   2. Download: iverilog-v12-20220611-x64_setup.exe
    echo   3. Run installer (use all defaults)
    echo   4. Restart computer
    echo   5. Run build.bat
    echo.
) else (
    iverilog -V | findstr "version"
    echo OK - Icarus Verilog found
)

echo.
echo ================================================================
echo.
echo Python packages installed successfully!
echo.
echo Next: Install Icarus Verilog manually (see above)
echo Then run: build.bat
echo.
pause