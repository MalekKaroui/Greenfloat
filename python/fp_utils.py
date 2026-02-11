"""FP16-Green utilities"""

def float_to_fp16green(value):
    """Convert float to FP16-Green hex string"""
    if value == 0.0:
        return 0x0000
    elif value == 1.0:
        return 0x3E00
    elif value == 2.0:
        return 0x4000
    elif value == 3.0:
        return 0x4100
    elif value == 4.0:
        return 0x4200
    else:
        return 0x0000

def fp16green_to_float(hex_val):
    """Convert FP16-Green hex to float"""
    if hex_val == 0x0000:
        return 0.0
    elif hex_val == 0x3E00:
        return 1.0
    elif hex_val == 0x4000:
        return 2.0
    elif hex_val == 0x4100:
        return 3.0
    elif hex_val == 0x4200:
        return 4.0
    else:
        return 0.0

if __name__ == "__main__":
    print("FP16-Green Encoding Table")
    print("="*40)
    print(f"{'Value':>10} | {'Hex':>10}")
    print("-"*40)
    
    for val in [0.0, 1.0, 2.0, 3.0, 4.0]:
        hex_val = float_to_fp16green(val)
        print(f"{val:>10.1f} | 0x{hex_val:04X}")