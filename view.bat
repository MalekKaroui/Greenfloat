@echo off
echo.
echo Opening GreenFloat Results...
echo.

REM Open the plots
if exist results\energy_comparison.png (
    echo Opening energy comparison plot...
    start results\energy_comparison.png
) else (
    echo Energy plot not found!
)

if exist results\error_distribution.png (
    echo Opening error distribution plot...
    start results\error_distribution.png
) else (
    echo Error plot not found!
)

echo.
echo Displaying CSV data:
echo.
type results\benchmark_results.csv
echo.
pause