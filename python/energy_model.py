"""Energy Model for GreenFloat"""

def calculate_energy_savings():
    """Calculate theoretical energy savings"""
    
    # Energy estimates (in picojoules)
    fp32_energy = 3.7  # pJ per operation
    fp16_energy = fp32_energy * (16/32)  # Linear scaling for adder
    
    savings = (1 - fp16_energy/fp32_energy) * 100
    
    print("\nGreenFloat Energy Analysis")
    print("="*40)
    print(f"FP32 Energy: {fp32_energy:.2f} pJ/op")
    print(f"FP16 Energy: {fp16_energy:.2f} pJ/op")
    print(f"Energy Savings: {savings:.1f}%")
    print("="*40)
    
    return savings

if __name__ == "__main__":
    calculate_energy_savings()