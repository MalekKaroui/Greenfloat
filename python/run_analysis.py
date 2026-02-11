"""GreenFloat Master Analysis Script"""

import os
import sys
from pathlib import Path

def print_banner():
    print("""
╔══════════════════════════════════════════════╗
║         GreenFloat Analysis Suite            ║
║   Variable-Precision FPU for Energy Savings  ║
╚══════════════════════════════════════════════╝
""")

def analyze_csv_results(filepath):
    """Analyze the benchmark CSV results"""
    if not os.path.exists(filepath):
        return None
    
    with open(filepath, 'r') as f:
        lines = f.readlines()
    
    if len(lines) <= 1:
        return None
    
    # Parse results
    fp16_tests = []
    fp32_tests = []
    
    for line in lines[1:]:  # Skip header
        parts = line.strip().split(',')
        if len(parts) >= 7:  # Changed from 6 to 7 to include Description
            mode = parts[0]
            op = parts[1]
            status = parts[6]  # Changed from parts[5] to parts[6]
            
            if mode == 'FP16':
                fp16_tests.append({'op': op, 'status': status})
            elif mode == 'FP32':
                fp32_tests.append({'op': op, 'status': status})
    
    # Calculate statistics
    fp16_pass = sum(1 for t in fp16_tests if t['status'] == 'PASS')
    fp16_total = len(fp16_tests)
    fp32_pass = sum(1 for t in fp32_tests if t['status'] == 'PASS')
    fp32_total = len(fp32_tests)
    
    return {
        'fp16': {'pass': fp16_pass, 'total': fp16_total},
        'fp32': {'pass': fp32_pass, 'total': fp32_total},
        'total_tests': fp16_total + fp32_total,
        'total_pass': fp16_pass + fp32_pass
    }
def calculate_energy_metrics():
    """Calculate detailed energy metrics"""
    
    # Energy parameters (in picojoules)
    fp32_add = 3.7
    fp32_mul = 3.7
    fp16_add = fp32_add * (16/32)  # Linear scaling
    fp16_mul = fp32_mul * (16/32)**2  # Quadratic scaling
    
    metrics = {
        'fp32_add': fp32_add,
        'fp32_mul': fp32_mul,
        'fp16_add': fp16_add,
        'fp16_mul': fp16_mul,
        'add_savings': (1 - fp16_add/fp32_add) * 100,
        'mul_savings': (1 - fp16_mul/fp32_mul) * 100
    }
    
    return metrics

def main():
    print_banner()
    
    # 1. FP Encoding Reference
    print("\n📊 1. FP16-Green Encoding Reference")
    print("=" * 50)
    import fp_utils
    print()
    
    # 2. Energy Analysis
    print("\n⚡ 2. Energy Analysis")
    print("=" * 50)
    
    metrics = calculate_energy_metrics()
    
    print(f"\nOperation Energy Comparison:")
    print(f"  FP32 Addition:       {metrics['fp32_add']:.2f} pJ")
    print(f"  FP16 Addition:       {metrics['fp16_add']:.2f} pJ")
    print(f"  Energy Savings:      {metrics['add_savings']:.1f}%")
    print()
    print(f"  FP32 Multiplication: {metrics['fp32_mul']:.2f} pJ")
    print(f"  FP16 Multiplication: {metrics['fp16_mul']:.2f} pJ")
    print(f"  Energy Savings:      {metrics['mul_savings']:.1f}%")
    
    avg_savings = (metrics['add_savings'] + metrics['mul_savings']) / 2
    print(f"\n  Average Savings:     {avg_savings:.1f}%")
    
    # 3. Visualization
    print("\n📈 3. Visualization")
    print("=" * 50)
    try:
        import plot_results
        plot_results.create_energy_plot()
        plot_results.create_error_plot()
    except Exception as e:
        print(f"Could not generate plots: {e}")
    
    # 4. Simulation Results
    print("\n✅ 4. Simulation Results")
    print("=" * 50)
    
    csv_file = "../results/benchmark_results.csv"
    results = analyze_csv_results(csv_file)
    
    if results:
        print(f"\nTest Results Summary:")
        print(f"  Total Tests:    {results['total_tests']}")
        print(f"  Tests Passed:   {results['total_pass']}")
        
        if results['fp16']['total'] > 0:
            fp16_rate = (results['fp16']['pass'] / results['fp16']['total']) * 100
            print(f"\n  FP16-Green:     {results['fp16']['pass']}/{results['fp16']['total']} ({fp16_rate:.1f}%)")
        
        if results['fp32']['total'] > 0:
            fp32_rate = (results['fp32']['pass'] / results['fp32']['total']) * 100
            print(f"  FP32 IEEE-754:  {results['fp32']['pass']}/{results['fp32']['total']} ({fp32_rate:.1f}%)")
        
        overall_rate = (results['total_pass'] / results['total_tests']) * 100
        print(f"\n  Overall Pass Rate: {overall_rate:.1f}%")
    else:
        print("\n  No simulation results found.")
        print("  Run simulation first to generate results.")
    
    # 5. Final Summary
    print("\n" + "=" * 50)
    print("📋 ANALYSIS SUMMARY")
    print("=" * 50)
    
    print(f"""
Key Findings:
  • Energy reduction: {avg_savings:.1f}% average
  • Addition saves:   {metrics['add_savings']:.1f}% energy
  • Multiply saves:   {metrics['mul_savings']:.1f}% energy
  • Bit-width ratio:  16/32 = 50%
  
Applications:
  • Machine Learning inference
  • Graphics processing  
  • Signal processing
  • IoT devices
  
Trade-offs:
  • Reduced precision (9-bit mantissa vs 23-bit)
  • Limited range (6-bit exponent vs 8-bit)
  • Suitable for error-tolerant applications
""")
    
    print("=" * 50)
    print("Analysis Complete! Check results/ folder for outputs.")
    print("=" * 50)

if __name__ == "__main__":
    main()