@echo off
setlocal

echo ========================================
echo      GreenFloat Build System
echo ========================================
echo.

:: Check what to do
if "%1"=="" goto :all
if "%1"=="sim" goto :sim
if "%1"=="analyze" goto :analyze
if "%1"=="clean" goto :clean
if "%1"=="help" goto :help
goto :help

:all
call :sim
call :analyze
goto :done

:sim
echo [1] Compiling SystemVerilog...
iverilog -g2012 -o greenfloat.vvp ^
    rtl\fp16_green_pkg.sv ^
    rtl\fp16_adder.sv ^
    rtl\fp16_multiplier.sv ^
    rtl\fp32_adder.sv ^
    rtl\fp32_multiplier.sv ^
    rtl\greenfloat_core.sv ^
    tb\benchmark_tb.sv

if errorlevel 1 (
    echo [ERROR] Compilation failed!
    echo Make sure Icarus Verilog is installed.
    pause
    exit /b 1
)

echo [2] Running simulation...
vvp greenfloat.vvp

if errorlevel 1 (
    echo [ERROR] Simulation failed!
    pause
    exit /b 1
)

echo [OK] Simulation complete!
echo.
goto :done

:analyze
echo [3] Running Python analysis...
cd python
python run_analysis.py
cd ..
echo.
goto :done

:clean
echo Cleaning...
if exist greenfloat.vvp del greenfloat.vvp
if exist results\*.* del results\*.* /q
echo Clean complete!
goto :done

:help
echo Usage: build.bat [command]
echo.
echo Commands:
echo   (none)  - Run everything
echo   sim     - Compile and simulate only
echo   analyze - Run Python analysis only  
echo   clean   - Remove generated files
echo   help    - Show this help
echo.
goto :done

:done
echo Done!
pause