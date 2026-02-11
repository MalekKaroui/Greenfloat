`timescale 1ns/1ps

package fp16_green_pkg;
    
    // FP16-Green Format: 1-bit sign, 6-bit exponent, 9-bit mantissa
    parameter FP16_WIDTH     = 16;
    parameter FP16_SIGN_BIT  = 15;
    parameter FP16_EXP_WIDTH = 6;
    parameter FP16_EXP_MSB   = 14;
    parameter FP16_EXP_LSB   = 9;
    parameter FP16_MAN_WIDTH = 9;
    parameter FP16_MAN_MSB   = 8;
    parameter FP16_MAN_LSB   = 0;
    parameter FP16_BIAS      = 31;
    parameter FP16_EXP_MAX   = 63;
    
    // FP32 IEEE-754 Format
    parameter FP32_WIDTH     = 32;
    parameter FP32_SIGN_BIT  = 31;
    parameter FP32_EXP_WIDTH = 8;
    parameter FP32_EXP_MSB   = 30;
    parameter FP32_EXP_LSB   = 23;
    parameter FP32_MAN_WIDTH = 23;
    parameter FP32_MAN_MSB   = 22;
    parameter FP32_MAN_LSB   = 0;
    parameter FP32_BIAS      = 127;
    parameter FP32_EXP_MAX   = 255;
    
endpackage