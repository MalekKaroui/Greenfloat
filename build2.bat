@echo off
setlocal enabledelayedexpansion

echo.
echo ╔══════════════════════════════════════════════╗
echo ║      GreenFloat Build System v2.0            ║
echo ╚══════════════════════════════════════════════╝
echo.

:: Create results directory if it doesn't exist
if not exist results (
    echo Creating results directory...
    mkdir results
)

:: Check command
if "%1"=="" goto :all
if "%1"=="sim" goto :sim_only
if "%1"=="analyze" goto :analyze_only
if "%1"=="clean" goto :clean
if "%1"=="test" goto :test
if "%1"=="help" goto :help
goto :help

:all
echo Running FULL BUILD...
echo ════════════════════
call :simulate
call :analyze
call :show_results
goto :done

:sim_only
call :simulate
call :show_results
goto :done

:analyze_only
call :analyze
call :show_results
goto :done

:simulate
echo.
echo [STEP 1/2] SystemVerilog Compilation and Simulation
echo ─────────────────────────────────────────────────────
echo.
echo Compiling design files...

:: Compile with explicit file list
iverilog -g2012 -o greenfloat.vvp ^
    rtl\fp16_green_pkg.sv ^
    rtl\fp16_adder.sv ^
    rtl\fp16_multiplier.sv ^
    rtl\fp32_adder.sv ^
    rtl\fp32_multiplier.sv ^
    rtl\greenfloat_core.sv ^
    tb\benchmark_tb.sv 2>&1

if errorlevel 1 (
    echo.
    echo ❌ ERROR: Compilation failed!
    echo.
    echo Possible issues:
    echo   1. Check if Icarus Verilog is installed
    echo   2. Check if all .sv files exist in rtl\ and tb\
    echo   3. Run "dir rtl\*.sv tb\*.sv" to verify files
    pause
    exit /b 1
)

echo ✓ Compilation successful
echo.
echo Running simulation...
echo ─────────────────────

vvp greenfloat.vvp

if errorlevel 1 (
    echo.
    echo ❌ ERROR: Simulation failed!
    pause
    exit /b 1
)

echo.
echo ✓ Simulation complete
exit /b 0

:analyze
echo.
echo [STEP 2/2] Python Analysis
echo ─────────────────────────────────────────────────────
echo.

:: Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: Python not found!
    echo Please install Python from python.org
    pause
    exit /b 1
)

:: Run analysis
cd python
python run_analysis.py
cd ..

echo.
echo ✓ Analysis complete
exit /b 0

:show_results
echo.
echo ══════════════════════════════════════════════════════
echo                    BUILD RESULTS
echo ══════════════════════════════════════════════════════
echo.

:: Check what files were created
if exist results\benchmark_results.csv (
    echo ✓ Simulation results: results\benchmark_results.csv
    
    :: Count lines in CSV
    for /f %%a in ('find /c /v "" ^< results\benchmark_results.csv') do set lines=%%a
    set /a tests=!lines!-1
    echo   Tests executed: !tests!
) else (
    echo ✗ No simulation results found
)

if exist results\greenfloat_benchmark.vcd (
    echo ✓ Waveform file: results\greenfloat_benchmark.vcd
    
    :: Get file size
    for %%a in (results\greenfloat_benchmark.vcd) do set size=%%~za
    echo   File size: !size! bytes
) else (
    echo ✗ No waveform file found
)

if exist results\energy_comparison.png (
    echo ✓ Energy plot: results\energy_comparison.png
) else (
    echo ✗ No energy plot found
)

if exist results\error_distribution.png (
    echo ✓ Error plot: results\error_distribution.png
) else (
    echo ✗ No error plot found
)

echo.
echo ══════════════════════════════════════════════════════
exit /b 0

:test
echo.
echo Testing Installation...
echo ──────────────────────
echo.

:: Test Python
echo Checking Python...
python --version 2>nul
if errorlevel 1 (
    echo   ❌ Python NOT found
    echo   Please install from: https://python.org
) else (
    echo   ✓ Python found
)

echo.
echo Checking Python packages...
python -c "import numpy; print('  ✓ numpy version:', numpy.__version__)" 2>nul || echo   ❌ numpy not installed
python -c "import matplotlib; print('  ✓ matplotlib version:', matplotlib.__version__)" 2>nul || echo   ❌ matplotlib not installed
python -c "import pandas; print('  ✓ pandas version:', pandas.__version__)" 2>nul || echo   ❌ pandas not installed

echo.
echo Checking Icarus Verilog...
iverilog -V 2>nul | findstr "version" || echo   ❌ Icarus Verilog NOT found

echo.
echo Checking project files...
if exist rtl\greenfloat_core.sv (
    echo   ✓ RTL files found
) else (
    echo   ❌ RTL files missing
)

if exist tb\benchmark_tb.sv (
    echo   ✓ Testbench found
) else (
    echo   ❌ Testbench missing
)

if exist python\run_analysis.py (
    echo   ✓ Python scripts found
) else (
    echo   ❌ Python scripts missing
)

echo.
goto :done

:clean
echo.
echo Cleaning project...
echo ─────────────────────

if exist greenfloat.vvp (
    del greenfloat.vvp
    echo   Deleted greenfloat.vvp
)

if exist results\*.* (
    del /q results\*.*
    echo   Cleaned results\
)

echo.
echo ✓ Clean complete
goto :done

:help
echo.
echo Usage: build2.bat [command]
echo.
echo Commands:
echo   (none)    Run full build (compile, simulate, analyze)
echo   sim       Run simulation only
echo   analyze   Run Python analysis only
echo   test      Test installation and dependencies
echo   clean     Remove all generated files
echo   help      Show this help message
echo.
echo Examples:
echo   build2.bat
:done
echo.
pause