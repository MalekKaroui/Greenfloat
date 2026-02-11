@echo off
echo Testing GreenFloat Installation...
echo.

echo Checking Python...
python --version
if errorlevel 1 (
    echo [ERROR] Python not found!
    echo Please install Python from python.org
) else (
    echo [OK] Python found
)

echo.
echo Checking Icarus Verilog...
iverilog -V 2>nul | findstr "version"
if errorlevel 1 (
    echo [ERROR] Icarus Verilog not found!
    echo Please install from: http://bleyer.org/icarus/
) else (
    echo [OK] Icarus Verilog found
)

echo.
pause