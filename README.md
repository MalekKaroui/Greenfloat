# GreenFloat: Variable-Precision FPU for Energy-Efficient Computing

A dual-precision floating-point unit demonstrating **62.5% energy savings** through precision scaling.

## Results

| Metric | Value |
|--------|-------|
| Tests Passing | 11/11 (100%) |
| Addition Savings | 50.0% |
| Multiplication Savings | 75.0% |
| Average Energy Savings | 62.5% |

## Quick Start

**Prerequisites:**
- Icarus Verilog: http://bleyer.org/icarus/
- Python 3: `pip install numpy matplotlib pandas`

**Run:**
```bash
build.bat
view.bat
## FP16-Green Format
Bit:  [15]   [14:9]     [8:0]
      Sign   Exponent   Mantissa
      1-bit  6-bit      9-bit

Bias = 31
Value = (-1)^S x 1.M x 2^(E-31)

## Architecture
GreenFloat Core
|-- FP16-Green Unit (16-bit)
|   |-- Adder
|   |-- Multiplier
|-- FP32 Unit (32-bit IEEE-754)
|   |-- Adder
|   |-- Multiplier
|-- Precision Controller

##Project Structure
greenfloat/
|-- rtl/           (SystemVerilog source - 6 files)
|-- tb/            (Testbench - 1 file)
|-- python/        (Analysis scripts - 4 files)
|-- results/       (Generated outputs)
|-- build.bat      (Build automation)

## Energy Analysis

Operation	FP32	FP16-Green	Savings
Addition	3.70 pJ	1.85 pJ	50.0%
Multiplication	3.70 pJ	0.93 pJ	75.0%
Average	-	-	62.5%

##  Test Results

Test	Status
FP16 ADD: 1.0 + 1.0 = 2.0	PASS
FP16 ADD: 2.0 + 2.0 = 4.0	PASS
FP16 ADD: 1.0 + 2.0 = 3.0	PASS
FP16 ADD: 2.0 + 1.0 = 3.0	PASS
FP16 ADD: 0.0 + 1.0 = 1.0	PASS
FP16 MUL: 2.0 x 2.0 = 4.0	PASS
FP16 MUL: 1.0 x 2.0 = 2.0	PASS
FP16 MUL: 2.0 x 1.0 = 2.0	PASS
FP32 ADD: 1.0 + 1.0 = 2.0	PASS
FP32 ADD: 2.0 + 2.0 = 4.0	PASS
FP32 MUL: 2.0 x 2.0 = 4.0	PASS

Applications
Machine Learning inference
Graphics processing
Signal processing
IoT edge computing
Battery-powered devices

Commands
Command	Description
build.bat	Full build and test
build.bat clean	Clean generated files
view.bat	View results and plots
Generated Files
File	Description
benchmark_results.csv	Test data
greenfloat_benchmark.vcd	Waveforms
energy_comparison.png	Energy plot
error_distribution.png	Accuracy plot
Author
Malek Karoui
University of New Brunswick
Computer Architecture
February 2026

License
Academic project for educational purposes.
