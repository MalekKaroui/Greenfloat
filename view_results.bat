@echo off
echo.
echo ══════════════════════════════════════
echo    GreenFloat Results Viewer
echo ══════════════════════════════════════
echo.

if not exist results\benchmark_results.csv (
    echo No results found! Run build.bat first.
    pause
    exit /b
)

echo Generated Files:
echo ─────────────────
dir /b results\*.*
echo.

echo Opening plots...
if exist results\energy_comparison.png start results\energy_comparison.png
if exist results\error_distribution.png start results\error_distribution.png

echo.
echo CSV Results Preview:
echo ────────────────────
type results\benchmark_results.csv
echo.

echo Test Summary:
echo ─────────────
for /f "tokens=*" %%a in ('find /c /v "" ^< results\benchmark_results.csv') do set lines=%%a
set /a tests=%lines%-1
echo Total tests: %tests%

findstr /c:"PASS" results\benchmark_results.csv > nul && (
    for /f %%a in ('findstr /c:"PASS" results\benchmark_results.csv ^| find /c "PASS"') do echo Passed: %%a
)

findstr /c:"FAIL" results\benchmark_results.csv > nul && (
    for /f %%a in ('findstr /c:"FAIL" results\benchmark_results.csv ^| find /c "FAIL"') do echo Failed: %%a
) || (
    echo Failed: 0
)

echo.
echo ══════════════════════════════════════
echo.
pause